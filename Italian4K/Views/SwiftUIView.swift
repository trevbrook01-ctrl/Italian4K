//
//  SwiftUIView.swift
//  Italian4K
//
//  Created by WARREN PETERS on 17/02/2026.
//

import SwiftUI

struct CategoryView: View {

    @StateObject private var viewModel = CategoryViewModel()
    @ObservedObject var purchaseService: PurchaseService
    @ObservedObject var quizViewModel: QuizViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingPaywall = false

    var body: some View {
        NavigationStack {
            List(viewModel.categories, id: \.id) { category in
                Button {
                    // Direct premium check against PurchaseService
                    if category.isPremium && !purchaseService.isProUnlocked {
                        showingPaywall = true
                    } else {
                        viewModel.selectedCategory = category
                        quizViewModel.loadCategory(category)
                        dismiss()
                    }
                } label: {
                    HStack {
                        Text(category.title)

                        Spacer()

                        // Show checkmark for currently selected category
                        if category.title == quizViewModel.currentCategoryTitle {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }

                        // Premium lock indicator
                        if category.isPremium && !purchaseService.isProUnlocked {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .listRowBackground(
                    category.title == quizViewModel.currentCategoryTitle
                        ? Color.accentColor.opacity(0.15)
                        : Color.clear
                )
            }
            .fullScreenCover(isPresented: $showingPaywall) {
                PaywallView()
            }
            .navigationTitle("Categories")
        }
    }
}
