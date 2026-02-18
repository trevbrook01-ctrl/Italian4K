//
//  ResultsView.swift
//  Italian4K
//
//  Created by WARREN PETERS on 17/02/2026.
//

import SwiftUI

struct ResultsView: View {
    let score: Int
    let total: Int

    var percentCorrect: Int {
        guard total > 0 else { return 0 }
        return Int((Double(score) / Double(total)) * 100)
    }

    var body: some View {
        ZStack {
            // App background styling (matches Home / Quiz screens)
            AppTheme.backgroundGradient
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Results")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.primary)
                    .padding(.bottom, 6)

                VStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .stroke(.gray.opacity(0.2), lineWidth: 12)

                        Circle()
                            .trim(from: 0, to: Double(percentCorrect) / 100.0)
                            .stroke(
                                AppTheme.primary,
                                style: StrokeStyle(lineWidth: 12, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                            .animation(.easeOut(duration: 0.6), value: percentCorrect)

                        VStack(spacing: 2) {
                            Text("\(percentCorrect)%")
                                .font(.title.weight(.bold))
                                .foregroundStyle(AppTheme.primary)

                            Text("correct")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(width: 140, height: 140)

                    Text("\(score) / \(total)")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.primary)
                }
                .padding(.vertical, 18)
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18))

                Text("Keep practising — consistency wins.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.top, 6)
            }
            .padding()
        }
    }
}

