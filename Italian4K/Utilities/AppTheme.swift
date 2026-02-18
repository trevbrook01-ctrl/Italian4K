//
//  AppTheme.swift
//  Italian4K
//
//  Created by WARREN PETERS on 17/02/2026.
//

import SwiftUI

enum AppTheme {

    // MARK: - Italian Theme

    static let accent = Color(red: 0.0, green: 0.57, blue: 0.27) // Italian flag green
    static let flagRed = Color(red: 0.8, green: 0.0, blue: 0.0) // Italian flag red
    static let flagWhite = Color(red: 0.98, green: 0.98, blue: 0.96) // Warm Italian white
    // Alias for older call sites
    static let primary = accent
    static let secondaryAccent = flagRed // Secondary accent now Italian red

    static let backgroundLight = flagWhite
    static let backgroundDark = Color(red: 0.07, green: 0.08, blue: 0.09)

    static let highlight = flagRed.opacity(0.12)

    // MARK: - Convenience background helpers

    static var background: Color {
        backgroundLight
    }

    static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [backgroundLight, backgroundLight.opacity(0.9)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
