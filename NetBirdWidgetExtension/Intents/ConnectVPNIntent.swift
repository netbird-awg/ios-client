import AppIntents
import NetworkExtension
import WidgetKit

@available(iOS 16.0, *)
struct ConnectVPNIntent: AppIntent {
    static var title: LocalizedStringResource = "Connect Netbird-AWG VPN"
    static var description: IntentDescription = "Connect to the Netbird-AWG VPN network."
    static var openAppWhenRun: Bool = false

    func perform() async throws -> some IntentResult & ProvidesDialog {
        guard let manager = try await VPNIntentHelpers.loadManager() else {
            WidgetCenter.shared.reloadAllTimelines()
            return .result(dialog: "Netbird-AWG VPN is not configured.")
        }

        guard !VPNIntentHelpers.isLoginRequired else {
            WidgetCenter.shared.reloadAllTimelines()
            return .result(dialog: "Netbird-AWG requires sign-in. Please open the app.")
        }

        let status = manager.connection.status
        guard status == .disconnected || status == .invalid else {
            return .result(dialog: "Netbird-AWG VPN is already \(WidgetVPNStatus(neStatus: status).displayText.lowercased()).")
        }

        VPNIntentHelpers.defaults?.set(WidgetVPNStatus.connecting.rawValue, forKey: WidgetConstants.keyVPNStatus)
        WidgetCenter.shared.reloadAllTimelines()

        let session = manager.connection as? NETunnelProviderSession
        do {
            try session?.startVPNTunnel()
        } catch {
            VPNIntentHelpers.defaults?.set(WidgetVPNStatus.disconnected.rawValue, forKey: WidgetConstants.keyVPNStatus)
            WidgetCenter.shared.reloadAllTimelines()
            throw error
        }

        let final = await VPNIntentHelpers.waitForStableState(manager: manager)
        if final == .connected {
            return .result(dialog: "Netbird-AWG VPN connected.")
        } else if VPNIntentHelpers.isLoginRequired {
            return .result(dialog: "Netbird-AWG requires sign-in. Please open the app.")
        } else {
            return .result(dialog: "Netbird-AWG VPN failed to connect.")
        }
    }
}
