import SwiftUI

/// Top-level Settings screen. Pushed from ProfileTab via gear icon.
/// Sections: Pro Tier (API key), Notifications (placeholder until Round 4),
/// About (version + privacy + support links), Data (reset).
struct SettingsView: View {
    @EnvironmentObject private var storage: Store
    @Environment(\.dismiss) private var dismiss

    @State private var showAPIKeySheet = false
    @State private var confirmClearData = false
    @State private var hasKey = Keychain.hasAPIKey()
    @State private var notifEnabled: Bool = DailyNotifications.isEnabled
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
                    proTierCard
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
                    .font(.system(size: 11))
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
        .alert("Clear all data?", isPresented: $confirmClearData) {
            Button("Cancel", role: .cancel) {}
            Button("Clear", role: .destructive) {
                storage.puzzleState = PuzzleState()
                storage.savePuzzleState()
                Keychain.deleteAPIKey()
                hasKey = false
                Haptics.shared.success()
            }
        } message: {
            Text("Deletes puzzle solves, ratings, streaks, and your Pro tier API key from this device. Cannot be undone.")
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
                    .font(.system(size: 18))
                    .foregroundStyle(hasKey ? Color.brandGreen : Color.textMuted)
                VStack(alignment: .leading, spacing: 2) {
                    Text(hasKey ? "Anthropic API key set" : "Set Anthropic API key")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.textPrimary)
                    Text(hasKey ? "Pro tier active. Bot ladder unlocked." : "Required to unlock the bot ladder.")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.textMuted)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
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

    private var notificationsPlaceholder: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "bell.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(notifEnabled ? Color.brandGreen : Color.textMuted)
                Text("Daily Drill reminder")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.textPrimary)
                Spacer()
                Toggle("", isOn: $notifEnabled)
                    .labelsHidden()
                    .tint(Color.brandGreen)
                    .onChange(of: notifEnabled) { _, on in
                        if on {
                            Task {
                                let granted = await DailyNotifications.requestAuthorization()
                                await MainActor.run {
                                    if granted {
                                        DailyNotifications.isEnabled = true
                                        DailyNotifications.schedule()
                                    } else {
                                        notifEnabled = false
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
            if notifEnabled {
                Divider().background(Color.border)
                HStack {
                    Text("Reminder time").font(.system(size: 14, weight: .semibold)).foregroundStyle(Color.textPrimary)
                    Spacer()
                    DatePicker("", selection: $notifTime, displayedComponents: .hourAndMinute)
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
                Image(systemName: icon).font(.system(size: 16)).foregroundStyle(Color.textMuted)
                Text(label).font(.system(size: 14, weight: .semibold)).foregroundStyle(Color.textPrimary)
                Spacer()
                Image(systemName: "arrow.up.right").font(.system(size: 12, weight: .bold)).foregroundStyle(Color.textFaint)
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
                    Text("Solved: \(storage.puzzleState.solves.filter(\.correct).count) puzzles")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.textPrimary)
                    Text("Current streak: \(storage.effectiveCurrentStreak)d · Longest: \(storage.puzzleState.longestStreak)d")
                        .font(.system(size: 11))
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
                    Image(systemName: "trash").font(.system(size: 16))
                    Text("Clear all data").font(.system(size: 14, weight: .semibold))
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

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Pro tier · Anthropic API key").microLabel(Color.brandGreen)
                    Text("Your key is stored in the iOS Keychain on this device only. It is sent directly to Anthropic to generate bot responses. Frame & Fork does not receive, log, or store it.")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.textSecondary)
                        .lineSpacing(3)
                        .padding(.bottom, 8)

                    HStack {
                        if showingKey {
                            TextField("sk-ant-...", text: $keyInput)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled(true)
                                .font(.system(size: 14, design: .monospaced))
                        } else {
                            SecureField("sk-ant-...", text: $keyInput)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled(true)
                                .font(.system(size: 14, design: .monospaced))
                        }
                        Button {
                            showingKey.toggle()
                        } label: {
                            Image(systemName: showingKey ? "eye.slash" : "eye")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.textMuted)
                        }
                    }
                    .padding(.horizontal, 12).padding(.vertical, 10)
                    .background(Color.bgPanel)
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 6, style: .continuous).strokeBorder(Color.border, lineWidth: 1))

                    HStack(spacing: 10) {
                        PrimaryButton(title: hasKey ? "Update key" : "Save key", symbol: "checkmark", isEnabled: !keyInput.trimmingCharacters(in: .whitespaces).isEmpty, style: .green) {
                            Keychain.saveAPIKey(keyInput.trimmingCharacters(in: .whitespaces))
                            hasKey = true
                            Haptics.shared.success()
                            dismiss()
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
                        .font(.system(size: 12))
                        .foregroundStyle(Color.textMuted)
                        .lineSpacing(2)

                    Link(destination: URL(string: "https://console.anthropic.com/settings/keys")!) {
                        HStack(spacing: 6) {
                            Text("Open console.anthropic.com").font(.system(size: 13, weight: .semibold)).foregroundStyle(Color.brandGreen)
                            Image(systemName: "arrow.up.right").font(.system(size: 11, weight: .bold)).foregroundStyle(Color.brandGreen)
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
                // Pre-populate if key exists, but mask by default
                if let existing = Keychain.loadAPIKey() {
                    keyInput = existing
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
