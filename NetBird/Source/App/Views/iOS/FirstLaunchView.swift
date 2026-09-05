//
//  FirstLaunchView.swift
//  NetBird
//
//  First-launch onboarding screen shown once to new users.
//

import SwiftUI

#if os(iOS)

struct FirstLaunchView: View {
    @Binding var hasCompletedOnboarding: Bool
    var onChangeServer: () -> Void

    var body: some View {
        ZStack {
            Color("BgPrimary")
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    Image("onboarding")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 180)

                    onboardingText

                    AppButton("Continue") {
                        hasCompletedOnboarding = true
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(32)
            }
        }
    }

    private var onboardingText: some View {
        VStack(spacing: 12) {
            Text("Before you connect")
                .font(.headline)
                .foregroundColor(Color("TextPrimary"))

            Text(
                "NetBird-AWG exchanges your sign-in identifier, device name, network " +
                "addresses, routes, peer metadata, and connection diagnostics with the " +
                "management, signal, and relay services selected by your organization. " +
                "This information is used only to authenticate your device and provide, " +
                "secure, and troubleshoot the VPN. It is not sold or used for advertising. " +
                "Debug bundles remain on this device unless you choose to share them."
            )
            .font(.subheadline)
            .foregroundColor(Color("TextSecondary"))

            Text("The configured NetBird-AWG server is used by default.")
                .font(.subheadline)
                .foregroundColor(Color("TextPrimary"))

            Button("Change server") {
                hasCompletedOnboarding = true
                onChangeServer()
            }
            .font(.subheadline.weight(.semibold))
            .foregroundColor(.orange)
            .accessibilityHint("Opens the management server settings")
        }
        .multilineTextAlignment(.center)
    }
}

#endif
