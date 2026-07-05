import SwiftUI
import StoreKit

/// Frame & Fork Pro paywall. Fully built and testable, but only surfaced when
/// `FeatureFlags.subscriptionsEnabled` is true (see FeatureFlags.swift / SECURITY.md):
/// a subscription only becomes meaningful and secure once the server proxy serves the LLM
/// and verifies the entitlement server-side.
struct PaywallView: View {
    @EnvironmentObject private var subscriptions: SubscriptionStore
    @Environment(\.dismiss) private var dismiss

    @State private var selected: Product? = nil
    @State private var purchasing = false

    private let features: [String] = [
        "Unlimited live role-play against AI buyer personas",
        "The blind AI coach grades the craft of every game",
        "The full bot ladder and persona library",
        "Your closer rating, tracked over time",
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                header
                featureList
                if subscriptions.isPro {
                    activeState
                } else {
                    planCards
                    subscribeButton
                    restoreButton
                }
                if let status = subscriptions.statusMessage {
                    Text(status).scaledFont(size: 12).foregroundStyle(Color.textMuted)
                }
                if let err = subscriptions.lastError {
                    Text(err).scaledFont(size: 12).foregroundStyle(Color.danger)
                }
                legal
                Spacer(minLength: 24)
            }
            .padding(.horizontal, 18)
            .padding(.top, 14)
        }
        .background(Color.bgPage)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.bgPage, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { dismiss() } label: {
                    Image(systemName: "xmark").scaledFont(size: 13, weight: .bold).foregroundStyle(Color.textMuted)
                        .accessibilityLabel("Close")
                }
            }
        }
        .task {
            if subscriptions.products.isEmpty { await subscriptions.loadProducts() }
            selected = selected ?? subscriptions.products.last   // default to the better-value (yearly) plan
        }
        .onChange(of: subscriptions.products) { _, new in
            if selected == nil { selected = new.last }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("FRAME & FORK").scaledFont(size: 11, weight: .heavy, design: .rounded).kerning(1).foregroundStyle(Color.brandGreen)
            Text("Pro").scaledFont(size: 34, weight: .heavy, design: .rounded).foregroundStyle(Color.textPrimary)
            Text("Practice closing against AI buyers who fight back, and get graded on the craft — not whether they caved.")
                .scaledFont(size: 14).foregroundStyle(Color.textSecondary).lineSpacing(3)
        }
    }

    private var featureList: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(features, id: \.self) { f in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "checkmark.circle.fill").scaledFont(size: 15).foregroundStyle(Color.brandGreen)
                    Text(f).scaledFont(size: 13.5).foregroundStyle(Color.textPrimary).lineSpacing(2)
                    Spacer(minLength: 0)
                }
            }
        }
    }

    @ViewBuilder
    private var planCards: some View {
        if subscriptions.isLoadingProducts {
            HStack { ProgressView().tint(Color.brandGreen); Text("Loading plans…").scaledFont(size: 13).foregroundStyle(Color.textMuted) }
                .frame(maxWidth: .infinity, alignment: .center).padding(.vertical, 12)
        } else if subscriptions.products.isEmpty {
            Text("Plans aren't available right now. Please try again later.")
                .scaledFont(size: 13).foregroundStyle(Color.textMuted)
        } else {
            VStack(spacing: 10) {
                ForEach(subscriptions.products, id: \.id) { product in planCard(product) }
            }
        }
    }

    private func planCard(_ product: Product) -> some View {
        let isSel = selected?.id == product.id
        return Button {
            Haptics.shared.selection()
            selected = product
        } label: {
            HStack(spacing: 12) {
                Image(systemName: isSel ? "largecircle.fill.circle" : "circle")
                    .scaledFont(size: 18).foregroundStyle(isSel ? Color.brandGreen : Color.textFaint)
                VStack(alignment: .leading, spacing: 2) {
                    Text(product.displayName).scaledFont(size: 14, weight: .bold).foregroundStyle(Color.textPrimary)
                    Text(product.description).scaledFont(size: 11.5).foregroundStyle(Color.textMuted).lineLimit(2)
                }
                Spacer(minLength: 8)
                HStack(alignment: .firstTextBaseline, spacing: 1) {
                    Text(product.displayPrice).scaledFont(size: 16, weight: .heavy, design: .rounded).foregroundStyle(Color.textPrimary)
                    Text(periodSuffix(product)).scaledFont(size: 11, weight: .bold, design: .rounded).foregroundStyle(Color.textMuted)
                }
            }
            .padding(13)
            .background(isSel ? Color.brandGreen.opacity(0.10) : Color.bgPanel)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(isSel ? Color.brandGreen : Color.border, lineWidth: isSel ? 1.5 : 1))
        }
        .buttonStyle(.plain)
    }

    private var subscribeButton: some View {
        PrimaryButton(title: purchasing ? "…" : "Subscribe", symbol: "lock.open.fill",
                      isEnabled: selected != nil && !purchasing, style: .green) {
            guard let product = selected else { return }
            purchasing = true
            Task {
                let ok = await subscriptions.purchase(product)
                purchasing = false
                if ok { Haptics.shared.success(); dismiss() }
            }
        }
    }

    private var restoreButton: some View {
        Button {
            Task { await subscriptions.restore(); if subscriptions.isPro { dismiss() } }
        } label: {
            Text("Restore purchases").scaledFont(size: 13, weight: .semibold).foregroundStyle(Color.textMuted)
                .frame(maxWidth: .infinity).padding(.vertical, 6)
        }
    }

    private var activeState: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.seal.fill").scaledFont(size: 20).foregroundStyle(Color.brandGreen)
            Text("You're Pro. Thank you.").scaledFont(size: 15, weight: .bold).foregroundStyle(Color.textPrimary)
            Spacer()
        }
        .padding(14)
        .background(Color.brandGreen.opacity(0.10))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).strokeBorder(Color.brandGreen.opacity(0.4), lineWidth: 1))
    }

    private var legal: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Subscriptions auto-renew until cancelled. Your account is charged for renewal within 24 hours prior to the end of the current period. Cancel anytime in your Apple ID settings at least 24 hours before the period ends. Payment is charged to your Apple ID.")
                .scaledFont(size: 10.5).foregroundStyle(Color.textFaint).lineSpacing(2)
            HStack(spacing: 14) {
                Link("Terms of Use", destination: URL(string: "https://moranetz.github.io/apps/frame-fork/terms.html")!)
                Link("Privacy Policy", destination: URL(string: "https://moranetz.github.io/apps/frame-fork/privacy.html")!)
            }
            .scaledFont(size: 10.5, weight: .semibold).tint(Color.textMuted)
        }
        .padding(.top, 4)
    }

    private func periodSuffix(_ product: Product) -> String {
        guard let p = product.subscription?.subscriptionPeriod else { return "" }
        switch p.unit {
        case .day:   return p.value == 1 ? "/day" : "/\(p.value)d"
        case .week:  return p.value == 1 ? "/wk" : "/\(p.value)wk"
        case .month: return p.value == 1 ? "/mo" : "/\(p.value)mo"
        case .year:  return p.value == 1 ? "/yr" : "/\(p.value)yr"
        @unknown default: return ""
        }
    }
}
