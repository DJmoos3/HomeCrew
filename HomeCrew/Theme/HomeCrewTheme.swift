//
//  HomeCrewTheme.swift
//  HomeCrew
//
//  Created by Omar Qasoma on 2026-05-21.
//

import SwiftUI

enum HomeCrewTheme {
    // Brand colors from the HomeCrew logo
    static let primaryPurple = Color(red: 0.48, green: 0.44, blue: 0.91)
    static let mintGreen = Color(red: 0.44, green: 0.82, blue: 0.70)
    static let darkBlue = Color(red: 0.03, green: 0.23, blue: 0.48)
    
    // Adaptive colors for Light/Dark Mode
    static let background = Color(.systemBackground)
    static let cardBackground = Color(.secondarySystemBackground)
    
    static let textPrimary = Color(.label)
    static let textSecondary = Color(.secondaryLabel)
    
    static let cornerRadius: CGFloat = 16
    static let cardHeight: CGFloat = 72
}
