import SwiftUI

/// Top-level Settings screen. Pushed from ProfileTab via gear icon.
/// Sections: Pro Tier (API key), Notifications (Daily Drill reminder),
/// About (version + privacy + support links), Data (reset).
struct SettingsView: View {
    @EnvironmentObject private var storage: Store
    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject private var subscriptions: SubscriptionStore
    @State private var showAPIKeySheet = false
    @State private var showPaywall = false
    @State private var confirmClearData = false
    @State private var hasKey = Keychain.hasAPIKey()
    @State private var notifEnabled: Bool = DailyNotifications.isEnabled
    @State private var notifDenied = false
    @State private var notifTime: Date = {
        var c = DateComponents()
        c.hour = DailyNotifications.hour
        c.minute = DailyNotifications.minute
        return Calendar.current.date(from: c) ?? Date()
    }()

    private let privacyURL = URL(string: "https://moranetz.github.io/apps/frame-fork/privacy.html")!
    private let supportURL = URL(string: "https://moranetz.github.io/apps/frame-fork/support.html")!
    private let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    private let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                section(title: "Pro Tier") {
                    if FeatureFlags.subscriptionsEnabled {
                        proSubscriptionCard
                        // The BYO-key card must stay reachable: gameplay still calls
                        // Anthropic directly with the Keychain key, so hiding this on
                        // flag-flip would strand subscribers (and existing key users)
                        // with an error pointing at UI that no longer exists.
                        proTierCard
                    } else {
                        proTierCard
                    }
                }

                section(title: "Your deals") {
                    companyDealsCard
                }

                section(title: "Notifications") {
                    notificationsPlaceholder
                }

                section(title: "About") {
                    aboutCard
                }

                section(title: "Data") {
                    dataCard
                }

                Text("Frame & Fork v\(appVersion) (build \(buildNumber)). Part of the Closer Foundation research program.")
                    .scaledFont(size: 11)
                    .foregroundStyle(Color.textFaint)
                    .padding(.top, 16)
                    .padding(.horizontal, 4)

                Spacer(minLength: 24)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
        .background(Color.bgPage)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(Color.bgPage, for: .navigationBar)
        .task {
            hasKey = Keychain.hasAPIKey()
            // If the user revoked notification permission in iOS Settings, the
            // toggle would otherwise keep showing "on" while nothing can fire.
            if DailyNotifications.isEnabled, await DailyNotifications.status() == .denied {
                DailyNotifications.isEnabled = false
                DailyNotifications.cancel()
                notifEnabled = false
            }
        }
        .sheet(isPresented: $showAPIKeySheet) {
            APIKeySheet(hasKey: $hasKey)
        }
        .sheet(isPresented: $showPaywall) {
            NavigationStack { PaywallView() }
        }
        .alert("Clear all data?", isPresented: $confirmClearData) {
            Button("Cancel", role: .cancel) {}
            Button("Clear", role: .destructive) {
                storage.puzzleState = PuzzleState()
                storage.savePuzzleState()
                storage.gameState = GameState()          // role-play transcripts + judgments
                storage.saveGameState()
                storage.companyProfile = CompanyProfile() // the team's product + objections (PII)
                storage.saveCompanyProfile()
                Keychain.deleteAPIKey()
                hasKey = false
                // Disarm the daily reminder too — a wiped account must not keep
                // getting "keep your streak alive" pings for a streak that's gone.
                DailyNotifications.isEnabled = false
                DailyNotifications.cancel()
                notifEnabled = false
                Haptics.shared.success()
            }
        } message: {
            Text("Deletes puzzle solves, ratings, streaks, role-play transcripts, your saved deal data, and your API key from this device. Cannot be undone.")
        }
    }

    // MARK: - Sections

    private func section<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).microLabel()
            content()
        }
    }

    private var proTierCard: some View {
        Button {
            Haptics.shared.light()
            showAPIKeySheet = true
        } label: {
            HStack {
                Image(systemName: hasKey ? "lock.shield.fill" : "lock.shield")
                    .scaledFont(size: 18)
                    .foregroundStyle(hasKey ? Color.brandGreen : Color.textMuted)
                VStack(alignment: .leading, spacing: 2) {
                    Text(hasKey ? "Anthropic API key set" : "Set Anthropic API key")
                        .scaledFont(size: 14, weight: .semibold)
                        .foregroundStyle(Color.textPrimary)
                    Text(hasKey ? "API key set. Bot ladder available." : "The bot ladder runs on your own Anthropic account.")
                        .scaledFont(size: 12)
                        .foregroundStyle(Color.textMuted)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .scaledFont(size: 12, weight: .bold)
                    .foregroundStyle(Color.textFaint)
            }
            .padding(14)
            .frame(maxWidth: .infinity)
            .background(Color.bgPanel)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).strokeBorder(hasKey ? Color.brandGreen.opacity(0.4) : Color.border, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    /// Shown when subscriptions are enabled (post-proxy). Opens the paywall.
    private var proSubscriptionCard: some View {
        Button {
            Haptics.shared.light()
            showPaywall = true
        } label: {
            HStack(spacing: 12) {
                Image(systemName: subscriptions.isPro ? "checkmark.seal.fill" : "sparkles")
                    .scaledFont(size: 18).foregroundStyle(Color.brandGreen).frame(width: 28)
                VStack(alignment: .leading, spacing: 2) {
                    Text(subscriptions.isPro ? "Frame & Fork Pro active" : "Get Frame & Fork Pro")
                        .scaledFont(size: 14, weight: .bold).foregroundStyle(Color.textPrimary)
                    Text(subscriptions.isPro ? "Unlimited role-play and the AI coach." : "Unlock unlimited role-play and the AI coach.")
                        .scaledFont(size: 12).foregroundStyle(Color.textMuted)
                }
                Spacer()
                Image(systemName: "chevron.right").scaledFont(size: 12, weight: .bold).foregroundStyle(Color.textFaint)
            }
            .padding(14)
            .frame(maxWidth: .infinity)
            .background(Color.bgPanel)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    /// "Train on your deals" — opens the company profile so role-play uses the team's real objections.
    private var companyDealsCard: some View {
        NavigationLink {
            CompanyProfileView()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: storage.companyProfile.isConfigured ? "target" : "scope")
                    .scaledFont(size: 18).foregroundStyle(Color.brandGreen).frame(width: 28)
                VStack(alignment: .leading, spacing: 2) {
                    Text(storage.companyProfile.isConfigured ? "Trained on your deals" : "Train on your deals")
                        .scaledFont(size: 14, weight: .bold).foregroundStyle(Color.textPrimary)
                    Text(storage.companyProfile.isConfigured
                         ? "Role-play buyers raise your real objections."
                         : "Make role-play buyers argue your real objections, not a generic script.")
                        .scaledFont(size: 12).foregroundStyle(Color.textMuted)
                }
                Spacer()
                Image(systemName: "chevron.right").scaledFont(size: 12, weight: .bold).foregroundStyle(Color.textFaint)
            }
            .padding(14)
            .frame(maxWidth: .infinity)
            .background(Color.bgPanel)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private var notificationsPlaceholder: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "bell.fill")
                    .scaledFont(size: 16)
                    .foregroundStyle(notifEnabled ? Color.brandGreen : Color.textMuted)
                Text("Daily Drill reminder")
                    .scaledFont(size: 14, weight: .semibold)
                    .foregroundStyle(Color.textPrimary)
                Spacer()
                Toggle("Daily Drill reminder", isOn: $notifEnabled)
                    .labelsHidden()
                    .tint(Color.brandGreen)
                    .onChange(of: notifEnabled) { _, on in
                        if on {
                            Task {
                                let granted = await DailyNotifications.requestAuthorization()
                                await MainActor.run {
                                    // The user may have flipped the toggle back OFF while the
                                    // authorization dialog was up — don't override their choice.
                                    guard notifEnabled else { return }
                                    if granted {
                                        DailyNotifications.isEnabled = true
                                        DailyNotifications.schedule()
                                        notifDenied = false
                                    } else {
                                        // iOS never re-prompts after a denial — without
                                        // guidance the toggle just "won't stay on".
                                        notifEnabled = false
                                        notifDenied = true
                                    }
                                }
                            }
                        } else {
                            DailyNotifications.isEnabled = false
                            DailyNotifications.cancel()
                        }
                    }
            }
            .padding(14)
            if notifDenied {
                Divider().background(Color.border)
                HStack(spacing: 8) {
                    Text("Notifications are off for Frame & Fork in iOS Settings.")
                        .scaledFont(size: 12)
                        .foregroundStyle(Color.textMuted)
                    Spacer(minLength: 8)
                    if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
                        Link("Open Settings", destination: url)
                            .scaledFont(size: 12, weight: .semibold)
                            .foregroundStyle(Color.brandGreen)
                    }
                }
                .padding(14)
            }
            if notifEnabled {
                Divider().background(Color.border)
                HStack {
                    Text("Reminder time").scaledFont(size: 14, weight: .semibold).foregroundStyle(Color.textPrimary)
                    Spacer()
                    DatePicker("Reminder time", selection: $notifTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .onChange(of: notifTime) { _, newTime in
                            let comps = Calendar.current.dateComponents([.hour, .minute], from: newTime)
                            DailyNotifications.hour = comps.hour ?? 9
                            DailyNotifications.minute = comps.minute ?? 0
                            DailyNotifications.schedule()
                        }
                }
                .padding(14)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    private var aboutCard: some View {
        VStack(spacing: 0) {
            linkRow(label: "Privacy Policy", icon: "lock.doc", url: privacyURL)
            Divider().background(Color.border)
            linkRow(label: "Support / FAQ", icon: "questionmark.circle", url: supportURL)
            Divider().background(Color.border)
            linkRow(label: "Source on GitHub", icon: "chevron.left.forwardslash.chevron.right", url: URL(string: "https://github.com/Moranetz/closer-gym-ios")!)
        }
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    private func linkRow(label: String, icon: String, url: URL) -> some View {
        Link(destination: url) {
            HStack {
                Image(systemName: icon).scaledFont(size: 16).foregroundStyle(Color.textMuted)
                Text(label).scaledFont(size: 14, weight: .semibold).foregroundStyle(Color.textPrimary)
                Spacer()
                Image(systemName: "arrow.up.right").scaledFont(size: 12, weight: .bold).foregroundStyle(Color.textFaint)
            }
            .padding(14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var dataCard: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Solved: \(storage.solvedUniqueCount) puzzles")
                        .scaledFont(size: 13, weight: .semibold)
                        .foregroundStyle(Color.textPrimary)
                    Text("Current streak: \(storage.effectiveCurrentStreak)d · Longest: \(storage.puzzleState.longestStreak)d")
                        .scaledFont(size: 11)
                        .foregroundStyle(Color.textMuted)
                }
                Spacer()
            }
            .padding(14)
            Divider().background(Color.border)
            Button {
                confirmClearData = true
            } label: {
                HStack {
                    Image(systemName: "trash").scaledFont(size: 16)
                    Text("Clear all data").scaledFont(size: 14, weight: .semibold)
                    Spacer()
                }
                .foregroundStyle(Color.danger)
                .padding(14)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }
}

// MARK: - API Key sheet

private struct APIKeySheet: View {
    @Binding var hasKey: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var keyInput: String = ""
    @State private var showingKey: Bool = false
    @State private var saveError: String? = nil
    @State private var keyHint: String? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Your Anthropic API key").microLabel(Color.brandGreen)
                    Text("Your key is stored in the iOS Keychain on this device only. It is sent directly to Anthropic to generate bot responses. Frame & Fork does not receive, log, or store it.")
                        .scaledFont(size: 13)
                        .foregroundStyle(Color.textSecondary)
                        .lineSpacing(3)
                        .padding(.bottom, 8)

                    if let keyHint {
                        Text(keyHint)
                            .scaledFont(size: 12, design: .monospaced)
                            .foregroundStyle(Color.textMuted)
                    }
                    HStack {
                        if showingKey {
                            TextField("sk-ant-...", text: $keyInput)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled(true)
                                .scaledFont(size: 14, design: .monospaced)
                        } else {
                            SecureField("sk-ant-...", text: $keyInput)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled(true)
                                .scaledFont(size: 14, design: .monospaced)
                        }
                        Button {
                            showingKey.toggle()
                        } label: {
                            Image(systemName: showingKey ? "eye.slash" : "eye")
                                .scaledFont(size: 14)
                                .foregroundStyle(Color.textMuted)
                        }
                    }
                    .padding(.horizontal, 12).padding(.vertical, 10)
                    .background(Color.bgPanel)
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 6, style: .continuous).strokeBorder(Color.border, lineWidth: 1))

                    if let saveError {
                        Text(saveError)
                            .scaledFont(size: 12)
                            .foregroundStyle(Color.dangerText)
                    }

                    HStack(spacing: 10) {
                        // Trim newlines too: a key pasted from a terminal/notes app often
                        // carries a trailing \n, and Foundation drops header values that
                        // contain newlines — the saved key then 401s forever while the
                        // UI says "Pro tier active".
                        PrimaryButton(title: hasKey ? "Update key" : "Save key", symbol: "checkmark", isEnabled: !keyInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, style: .green) {
                            if Keychain.saveAPIKey(keyInput.trimmingCharacters(in: .whitespacesAndNewlines)) {
                                hasKey = true
                                saveError = nil
                                Haptics.shared.success()
                                dismiss()
                            } else {
                                saveError = "Couldn't save the key to the Keychain. Try again, or restart the app."
                                Haptics.shared.error()
                            }
                        }
                        if hasKey {
                            SecondaryButton(title: "Remove", symbol: "trash") {
                                Keychain.deleteAPIKey()
                                hasKey = false
                                keyInput = ""
                                Haptics.shared.medium()
                                dismiss()
                            }
                        }
                    }
                    .padding(.top, 4)

                    Text("Where to get a key").microLabel()
                    Text("Sign in at console.anthropic.com, then go to API Keys and create a new key. The string starts with sk-ant-.")
                        .scaledFont(size: 12)
                        .foregroundStyle(Color.textMuted)
                        .lineSpacing(2)

                    Link(destination: URL(string: "https://console.anthropic.com/settings/keys")!) {
                        HStack(spacing: 6) {
                            Text("Open console.anthropic.com").scaledFont(size: 13, weight: .semibold).foregroundStyle(Color.brandGreen)
                            Image(systemName: "arrow.up.right").scaledFont(size: 11, weight: .bold).foregroundStyle(Color.brandGreen)
                        }
                    }

                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
            .background(Color.bgPage)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.bgPage, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") { dismiss() }.foregroundStyle(Color.textSecondary)
                }
            }
            .onAppear {
                // NEVER pre-populate the field with the stored key: combined with the
                // eye toggle it echoed the full billing-bearing secret to anyone
                // holding the unlocked phone. Show a masked hint; input replaces.
                if let existing = Keychain.loadAPIKey(), existing.count > 6 {
                    keyHint = "Saved key: sk-ant-…\(existing.suffix(4))"
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
