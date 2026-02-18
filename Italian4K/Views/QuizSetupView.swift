//
//  QuizSetupView.swift
//  Italian4K
//
//  Created by WARREN PETERS on 17/02/2026.
//

import SwiftUI

struct QuizSetupView: View {
    @ObservedObject var viewModel: QuizViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var questionCount = 10
    @State private var direction: QuizViewModel.QuizDirection = .sourceToTarget

    var body: some View {
        NavigationStack {
            Form {
                Section("Questions") {
                    Picker("Number of questions", selection: $questionCount) {
                        Text("10").tag(10)
                        Text("20").tag(20)
                        Text("30").tag(30)
                    }
                    .pickerStyle(.segmented)
                }

                Section("Direction") {
                    Picker("Test direction", selection: $direction) {
                        Text("English → Italian").tag(QuizViewModel.QuizDirection.sourceToTarget)
                        Text("Italian → English").tag(QuizViewModel.QuizDirection.targetToSource)
                    }
                    .pickerStyle(.inline)
                }

                Section {
                    Button("Start") {
                        viewModel.startSession(totalQuestions: questionCount, direction: direction)
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Quiz Setup")
            .onAppear {
                // Sync picker defaults with last persisted quiz settings
                questionCount = viewModel.totalQuestions
                direction = viewModel.direction
            }
        }
    }
}
