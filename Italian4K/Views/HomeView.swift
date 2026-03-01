//
//  HomeView.swift
//  Italian4K
//
//  Created by WARREN PETERS on 17/02/2026.
//

import SwiftUI

struct HomeView: View {
    @StateObject var quizViewModel = QuizViewModel()
    @StateObject var categoryViewModel = CategoryViewModel()
    @StateObject private var purchaseService = PurchaseService.shared
    
    @State private var showingCategories = false
    @State private var showingSetup = false
    @State private var showingQuiz = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        AppTheme.accent.opacity(0.08),
                        Color(.systemBackground)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            VStack(spacing: 24) {
                Text(quizViewModel.currentCategoryTitle ?? "Select Category")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.primary)

                let directionText = quizViewModel.direction == .sourceToTarget
                    ? "English → Italian"
                    : "Italian → English"

                VStack(spacing: 6) {
                    Button("\(quizViewModel.totalQuestions) questions • \(directionText)") {
                        showingSetup = true
                    }
                    .font(.subheadline.weight(.medium))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(AppTheme.accent.opacity(0.12), in: Capsule())
                    .foregroundStyle(AppTheme.accent)
                    
                    Text("Tap to change")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                Button("Start Quiz") {
                    // ensure last category is restored before deciding flow
                    quizViewModel.restoreLastCategoryIfNeeded(
                        from: categoryViewModel.categories
                    )

                    if quizViewModel.currentCategoryTitle != nil {
                        // always reset quiz state before starting
                        quizViewModel.resetForNewGame()

                        showingCategories = false
                        showingSetup = false
                        showingQuiz = true
                    } else {
                        showingCategories = true
                    }
                }
                .font(.headline)
                .buttonStyle(.borderedProminent)
                .tint(AppTheme.accent)

                Button("Change Category") {
                    showingCategories = true
                }
                .font(.subheadline)
                .buttonStyle(.bordered)
            }
            .padding()
            }
            .navigationTitle("Italian 4K")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showingCategories) {
                CategoryView(
                    purchaseService: purchaseService,
                    quizViewModel: quizViewModel
                )
            }
            .sheet(isPresented: $showingSetup) {
                QuizSetupView(viewModel: quizViewModel)
            }
            .fullScreenCover(isPresented: $showingQuiz) {
                ContentView(viewModel: quizViewModel)
            }
            .onAppear {
                showingCategories = false
                showingQuiz = false
                quizViewModel.restoreLastCategoryIfNeeded(
                    from: categoryViewModel.categories
                )
            }
        }
    }
}

#Preview {
    HomeView()
}
