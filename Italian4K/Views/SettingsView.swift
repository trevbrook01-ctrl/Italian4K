//
//  SettingsView.swift
//  Italian4K
//
//  Created by WARREN PETERS on 01/03/2026.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.openURL) private var openURL
    @State private var isPaywallPresented = false
    @AppStorage("isProUnlocked") private var isProUnlocked = false
    var body: some View {
        NavigationStack {
            List {
                Section("About") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Italian 4K")
                            .font(.headline)
                        Text("Learn everyday Italian words with quick, focused quizzes across themed categories.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }

                Section("App Info") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                            .foregroundStyle(.secondary)
                    }
                }
                if !isProUnlocked {
                    Section("Upgrade") {
                        Button {
                            isPaywallPresented = true
                        } label: {
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(.yellow)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Upgrade to Pro")
                                        .font(.headline)
                                    Text("Unlock all vocabulary categories — one-time purchase, no ads.")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                Section("Support") {
                    Button("Rate App") {
                        openURL(URL(string: "https://apps.apple.com/app/id6759345836")!)
                    }

                    Button("Write a Review") {
                        openURL(URL(string: "https://apps.apple.com/app/id6759345836?action=write-review")!)
                    }
                    Button {
                        openURL(URL(string: "https://apps.apple.com/app/id1591974617")!)
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Learn Spanish")
                                .font(.headline)
                            Text("Master Spanish vocabulary with focused drills")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }

                    Link("Privacy Policy",
                         destination: URL(string: "https://simpleisainfo.com/italian-4k-privacy-policy/")!)

                    Link("Website",
                         destination: URL(string: "https://simpleisainfo.com/italian-4k-user-guide/")!)

                    Link("Contact Support",
                         destination: URL(string: "mailto:peters456@btinernet.com?subject=Italian%204K%20Vocabulary%20Support")!)
                        .foregroundStyle(.primary)
                }
            }
            .navigationTitle("Settings")
            .fullScreenCover(isPresented: $isPaywallPresented) {
                PaywallView()
            }
        }
    }
}

#Preview {
    SettingsView()
}

