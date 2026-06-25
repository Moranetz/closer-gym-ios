import SwiftUI

/// "Train on your deals" — captures the team's product + real objections so the role-play buyer
/// argues with THEIR deals instead of a generic script. Works today on the existing key.
/// Stored on-device only; see CompanyProfile for the (consented, backend-gated) data-flywheel use.
struct CompanyProfileView: View {
    @EnvironmentObject private var storage: Store
    @Environment(\.dismiss) private var dismiss

    @State private var productName = ""
    @State private var productDescription = ""
    @State private var idealCustomer = ""
    @State private var objectionsText = ""        // one per line
    @State private var competitorsText = ""
    @State private var differentiatorsText = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                intro
                field("What you sell", "e.g. Acme Analytics", $productName)
                field("What it does (1–2 lines)", "Real-time revenue analytics for RevOps teams", $productDescription, lines: 2...4)
                field("Who you sell to", "e.g. RevOps leads at mid-market SaaS", $idealCustomer)
                field("Objections you actually hear (one per line)",
                      "It's not in this year's budget\nWe already use a competitor\nWe don't have time to switch",
                      $objectionsText, lines: 3...8)
                field("Competitors (one per line, optional)", "", $competitorsText, lines: 2...5)
                field("Your real differentiators (one per line, optional)", "", $differentiatorsText, lines: 2...5)
                privacyNote
                saveButton
                Spacer(minLength: 24)
            }
            .padding(16)
        }
        .background(Color.bgPage)
        .navigationTitle("Train on your deals")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.bgPage, for: .navigationBar)
        .onAppear(perform: load)
    }

    private var intro: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Make the practice real").font(.system(size: 17, weight: .heavy, design: .rounded)).foregroundStyle(Color.textPrimary)
            Text("The role-play buyers will raise the objections your deals actually stall on, instead of a generic script. The more real the objections, the more the practice transfers.")
                .font(.system(size: 13)).foregroundStyle(Color.textSecondary).lineSpacing(3)
        }
    }

    private func field(_ label: String, _ placeholder: String, _ text: Binding<String>, lines: ClosedRange<Int> = 1...1) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).microLabel(Color.textSecondary)
            TextField(placeholder, text: text, axis: .vertical)
                .font(.system(size: 14))
                .foregroundStyle(Color.textPrimary)
                .tint(Color.brandGreen)
                .lineLimit(lines)
                .padding(.horizontal, 11).padding(.vertical, 9)
                .background(Color.bgPanel)
                .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 9, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
        }
    }

    private var privacyNote: some View {
        Text("Stored on this device — Frame & Fork has no server and never receives this. During a role-play, this context is included in the prompt sent to Anthropic with your own API key (the same as your typed turns).")
            .font(.system(size: 11)).foregroundStyle(Color.textFaint).lineSpacing(2)
    }

    private var saveButton: some View {
        PrimaryButton(title: "Save", symbol: "checkmark", isEnabled: true, style: .green) {
            save()
            Haptics.shared.success()
            dismiss()
        }
        .padding(.top, 2)
    }

    private func load() {
        let p = storage.companyProfile
        productName = p.productName
        productDescription = p.productDescription
        idealCustomer = p.idealCustomer
        objectionsText = p.objections.joined(separator: "\n")
        competitorsText = p.competitors.joined(separator: "\n")
        differentiatorsText = p.differentiators.joined(separator: "\n")
    }

    private func save() {
        // Bound every field so a giant paste can't inflate every role-play request for the life
        // of the profile (cost/latency — matches the per-turn cap; see SECURITY.md defense-in-depth).
        var p = CompanyProfile()
        p.productName = cap(productName, 120)
        p.productDescription = cap(productDescription, 400)
        p.idealCustomer = cap(idealCustomer, 200)
        p.objections = lines(objectionsText, maxItems: 15, maxLen: 240)
        p.competitors = lines(competitorsText, maxItems: 12, maxLen: 120)
        p.differentiators = lines(differentiatorsText, maxItems: 12, maxLen: 240)
        storage.companyProfile = p
        storage.saveCompanyProfile()
    }

    private func cap(_ s: String, _ n: Int) -> String {
        String(s.trimmingCharacters(in: .whitespacesAndNewlines).prefix(n))
    }

    private func lines(_ s: String, maxItems: Int, maxLen: Int) -> [String] {
        s.split(separator: "\n")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .prefix(maxItems)
            .map { String($0.prefix(maxLen)) }
    }
}
