import Foundation
import StoreKit

/// StoreKit 2 client for Frame & Fork Pro (auto-renewable subscription).
///
/// SECURITY (see SECURITY.md): `isPro` here is a CLIENT-SIDE UX signal only — it is NOT a
/// security boundary. A jailbroken device can spoof StoreKit, so before a subscription gates
/// anything that costs the owner money (the LLM proxy), the SERVER must independently verify
/// the entitlement with Apple's App Store Server API and recompute access there. Until that
/// proxy exists, subscriptions stay behind `FeatureFlags.subscriptionsEnabled` and BYO-key
/// remains the functional path (a subscription has nothing to unlock yet).
@MainActor
public final class SubscriptionStore: ObservableObject {
    public static let monthlyID = "com.melmarion.FrameFork.pro.monthly"
    public static let yearlyID  = "com.melmarion.FrameFork.pro.yearly"
    public static let productIDs = [monthlyID, yearlyID]

    @Published public private(set) var products: [Product] = []
    @Published public private(set) var isPro: Bool = false        // UX entitlement only — never trusted as a boundary
    @Published public private(set) var isLoadingProducts = false
    @Published public var lastError: String? = nil          // genuine errors (red)
    @Published public private(set) var statusMessage: String? = nil   // neutral info (pending / nothing-to-restore)

    private var updatesTask: Task<Void, Never>? = nil

    public init() {
        // No StoreKit work until subscriptions are actually live — avoids a needless network
        // round-trip at every launch while the feature is flagged off (and there are no products).
        guard FeatureFlags.subscriptionsEnabled else { return }
        // Start the transaction listener BEFORE any purchase, so transactions that arrive
        // out-of-band — Ask-to-Buy approval, auto-renewals, a restore on another device,
        // refunds/revocations — are never missed. (Classic StoreKit mistake: only handling
        // the value returned by purchase().)
        updatesTask = listenForTransactions()
        Task { await loadProducts(); await refreshEntitlement() }
    }

    deinit { updatesTask?.cancel() }

    public func loadProducts() async {
        isLoadingProducts = true
        lastError = nil                       // clear a prior failure so a successful retry isn't shown red
        defer { isLoadingProducts = false }
        do {
            let loaded = try await Product.products(for: Self.productIDs)
            products = loaded.sorted { $0.price < $1.price }   // monthly before yearly
            if loaded.isEmpty { lastError = "No subscription options are available right now." }
        } catch {
            lastError = "Couldn't load subscription options. Check your connection and try again."
        }
    }

    /// Returns true if the purchase produced an active entitlement.
    @discardableResult
    public func purchase(_ product: Product) async -> Bool {
        lastError = nil
        statusMessage = nil
        do {
            // When subscriptions go live with the server proxy, pass
            // `options: [.appAccountToken(<stable per-account UUID>)]` so the App Store Server
            // API can tie each transaction to a verified account (can't be retrofitted later).
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()        // MUST finish or StoreKit re-delivers it forever
                await refreshEntitlement()
                return isPro
            case .pending:
                // Ask-to-Buy / Strong Customer Authentication: a NORMAL state, not an error. The
                // entitlement (if approved) arrives later via the updates listener, not here.
                statusMessage = "Purchase pending approval — it'll unlock automatically once approved."
                return false
            case .userCancelled:
                return false
            @unknown default:
                return false
            }
        } catch {
            lastError = "Purchase failed. \(error.localizedDescription)"
            return false
        }
    }

    public func restore() async {
        lastError = nil
        statusMessage = nil
        do {
            try await AppStore.sync()             // re-surfaces past purchases to StoreKit
        } catch {
            lastError = "Restore failed. \(error.localizedDescription)"
        }
        await refreshEntitlement()                // currentEntitlements is the source of truth either way
        if !isPro, lastError == nil { statusMessage = "No purchases found to restore." }
    }

    /// Recompute `isPro` from the system's source of truth (active, non-revoked, verified
    /// entitlements). Called after purchase, restore, launch, and every out-of-band update.
    public func refreshEntitlement() async {
        var active = false
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }   // ignore unverified
            if Self.productIDs.contains(transaction.productID), transaction.revocationDate == nil {
                active = true
            }
        }
        isPro = active
    }

    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                guard let self else { break }   // store deallocated — stop consuming
                guard case .verified(let transaction) = result else { continue }
                await transaction.finish()
                await self.refreshEntitlement()
            }
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let safe): return safe
        case .unverified: throw StoreError.failedVerification
        }
    }

    enum StoreError: Error { case failedVerification }
}
