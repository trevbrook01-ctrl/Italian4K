//
//  GameCompleteView.swift
//  Italian4K
//
//  Created by WARREN PETERS on 17/02/2026.
//

import SwiftUI

struct GameCompleteView: View {
    let score: Int
    let totalQuestions: Int
    let categoryTitle: String
    let onRestart: () -> Void
    
    private var percentage: Int {
        guard totalQuestions > 0 else { return 0 }
        return Int((Double(score) / Double(totalQuestions)) * 100)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text("\(categoryTitle) Complete")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            Text("\(score) / \(totalQuestions)")
                .font(.system(size: 48, weight: .bold))

            Text("\(percentage)% correct")
                .font(.headline)
                .foregroundStyle(.secondary)

            Button("Try Again") {
                onRestart()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 12)
        }
        .padding()
    }
}

#Preview {
    GameCompleteView(
        score: 8,
        totalQuestions: 10,
        categoryTitle: "Animals",
        onRestart: {}
    )
}
