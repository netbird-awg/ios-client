import SwiftUI
import WidgetKit

@available(iOS 18.0, *)
struct NetBirdVPNControl: ControlWidget {

    static let kind = "io.netbird.vpn.control"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(
            kind: Self.kind,
            provider: VPNControlProvider()
        ) { state in
            ControlWidgetToggle(
                isOn: state.isActive,
                action: SetVPNStateIntent()
            ) { 
                Label("Netibird-AWG VPN", image: "netbird-logo")
            }
            .tint(Color(red: 0xF6/255, green: 0x83/255, blue: 0x30/255))
        }
        .displayName("Netibird-AWG VPN")
        .description("Connect or disconnect Netibird-AWG VPN from Control Center.")
    }
}
