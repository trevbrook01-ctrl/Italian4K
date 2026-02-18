//
//  ContentView.swift
//  Italian4K
//
//  Created by WARREN PETERS on 17/02/2026.
//

import SwiftUI
import AudioToolbox
import UIKit
import StoreKit

struct ContentView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: QuizViewModel

    init(viewModel: QuizViewModel = QuizViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.backgroundGradient // themed background gradient
                    .ignoresSafeArea()

                VStack(spacing: 24) {

                    if viewModel.isFinished {
                        GameCompleteView(
                            score: viewModel.score,
                            totalQuestions: viewModel.totalQuestions,
                            categoryTitle: viewModel.currentCategoryTitle ?? "",
                            onRestart: {
                                viewModel.startSession(
                                    totalQuestions: viewModel.totalQuestions,
                                    direction: viewModel.direction
                                )
                            }
                        )
                    } else {

                        Text("Score: \(viewModel.score)")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.secondary)


                        Text(viewModel.promptText())
                            .font(.largeTitle.weight(.bold))
                            .padding(.bottom, 6)

                        if viewModel.showFeedback {
                            Text(viewModel.color(for: viewModel.selectedAnswer!) == .green ? "Correct ✓" : "Incorrect — correct answer highlighted")
                                .font(.headline.weight(.semibold))
                                .foregroundStyle(viewModel.color(for: viewModel.selectedAnswer!) == .green ? .green : .secondary)
                                .transition(.opacity)
                        }

                        if viewModel.currentItem != nil {
                            ForEach(viewModel.answerChoices(), id: \.id) { item in
                                let isCorrect = item.id == viewModel.currentItem?.id
                                let isSelected = viewModel.selectedAnswer?.id == item.id
                                Button {
                                    viewModel.selectAnswer(item)

                                    // Haptic feedback
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(viewModel.color(for: item) == .green ? .success : .error)

                                    // Soft system sound
                                    AudioServicesPlaySystemSound(1104)
                                } label: {
                                    HStack {
                                        Text(viewModel.optionText(for: item))
                                            .lineLimit(nil)
                                            .multilineTextAlignment(.leading)
                                            .fixedSize(horizontal: false, vertical: true)
                                        Spacer()

                                        if viewModel.showFeedback &&
                                           viewModel.color(for: item) == .green {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundStyle(.white)
                                        }
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .tint(viewModel.showFeedback && isCorrect ? Color.green : viewModel.color(for: item))
                                .allowsHitTesting(viewModel.selectedAnswer == nil)
                                .opacity(
                                    viewModel.selectedAnswer == nil ? 1 :
                                    (isCorrect ? 1 : 0.25)
                                )
                                .fontWeight(viewModel.showFeedback && isCorrect ? .semibold : .regular)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(isCorrect && viewModel.showFeedback ? Color.green.opacity(0.8) : Color.clear, lineWidth: 2)
                                )
                                .scaleEffect(
                                    viewModel.showFeedback && viewModel.color(for: item) == .green ? 1.02 : 1
                                )
                                .animation(.spring(response: 0.3), value: viewModel.showFeedback)
                            }
                        }

                        Button(viewModel.showFeedback ? "Next Question" : "Select an answer") {
                            viewModel.nextQuestion()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(AppTheme.primary)
                        .disabled(viewModel.selectedAnswer == nil)
                    }
                }
                .padding()
            }
            .onChange(of: viewModel.isFinished) { finished in
                guard finished else { return }

                let key = "reviewPromptCount"
                let count = UserDefaults.standard.integer(forKey: key) + 1
                UserDefaults.standard.set(count, forKey: key)

                // Only prompt occasionally (e.g. every 3 completed quizzes)
                if count % 3 == 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            SKStoreReviewController.requestReview(in: scene)
                        }
                    }
                }
            }
            .navigationTitle(viewModel.isFinished ? "Results" : (viewModel.currentCategoryTitle ?? "Quiz"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("New Game") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
