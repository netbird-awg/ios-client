import AppIntents
import NetworkExtension

@available(iOS 16.0, *)
struct VPNStatusIntent: AppIntent {
    static var title: LocalizedStringResource = "Get Netibird-AWG VPN Status"
    static var description: IntentDescription = "Check whether Netibird-AWG VPN is connected."
    static var openAppWhenRun: Bool = false

    func perform() async throws -> some IntentResult & ProvidesDialog {
        guard let manager = try await VPNIntentHelpers.loadManager() else {
            return .result(dialog: "Netibird-AWG VPN is not configured.")
        }

        if VPNIntentHelpers.isLoginRequired {
            return .result(dialog: "Netibird-AWG VPN requires sign-in.")
        }

        let status = WidgetVPNStatus(neStatus: manager.connection.status)
        let ip = VPNIntentHelpers.defaults?.string(forKey: WidgetConstants.keyIP) ?? ""
        let detail = status == .connected && !ip.isEmpty ? " Your IP is \(ip)." : ""

        return .result(dialog: "Netibird-AWG VPN is \(status.displayText.lowercased()).\(detail)")
    }
}
