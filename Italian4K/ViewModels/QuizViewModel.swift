//
//  QuizViewModel.swift
//  Italian4K
//
//  Created by WARREN PETERS on 17/02/2026.
//

import Foundation
import SwiftUI
import Combine

class QuizViewModel: ObservableObject {

    // MARK: - Published State

    @Published private(set) var items: [VocabularyItem] = []
    @Published private(set) var currentItem: VocabularyItem?
    @Published private(set) var score: Int = 0
    @Published private(set) var selectedAnswer: VocabularyItem?
    @Published private(set) var showFeedback = false
    @Published private(set) var currentChoices: [VocabularyItem] = []
    @Published private(set) var currentCategoryTitle: String?

    private let lastCategoryKey = "lastCategoryTitle"
    private let lastQuestionCountKey = "lastQuestionCount"
    private let lastDirectionKey = "lastDirection"
    

    // MARK: - Init

    init() {
        // Restore last session preferences (category reload handled elsewhere)
        if let savedDirection = UserDefaults.standard.string(forKey: lastDirectionKey),
           let dir = QuizDirection(rawValue: savedDirection) {
            direction = dir
        }

        let savedCount = UserDefaults.standard.integer(forKey: lastQuestionCountKey)
        if savedCount == 10 || savedCount == 20 || savedCount == 30 {
            totalQuestions = savedCount
        }
        if let savedCategory = UserDefaults.standard.string(forKey: lastCategoryKey) {
            currentCategoryTitle = savedCategory
        }
    }

    // Restore full category data after CategoryViewModel provides categories
    func restoreLastCategoryIfNeeded(from categories: [Category]) {
        guard items.isEmpty,
              let savedTitle = UserDefaults.standard.string(forKey: lastCategoryKey),
              let category = categories.first(where: { $0.title == savedTitle })
        else { return }

        loadCategory(category)
    }


    // MARK: - Category Loading (from CategoryView)

    func loadCategory(_ category: Category) {
        currentCategoryTitle = category.title
        UserDefaults.standard.set(category.title, forKey: lastCategoryKey)

        items = category.fileNames.flatMap {
            DataLoader.loadVocabulary(from: $0)
        }

        // Reset session state so questions actually load
        score = 0
        questionsAnswered = 0
        isFinished = false
        isInSession = true

        selectedAnswer = nil
        showFeedback = false

        nextQuestion()
    }

    // MARK: - Question Flow


    // MARK: - Answer Logic

    func answerChoices() -> [VocabularyItem] {
        currentChoices
    }


    // MARK: - UI Feedback Helper

    func color(for item: VocabularyItem) -> Color {
        guard showFeedback,
              let selected = selectedAnswer,
              let current = currentItem else {
            return .primary
        }

        if item.id == current.id {
            return .green
        }

        if item.id == selected.id {
            return .red
        }

        return .primary
    }
    
    enum QuizDirection: String, CaseIterable, Identifiable {
        case sourceToTarget  // English -> Russian
        case targetToSource  // Russian -> English
        var id: String { rawValue }
    }

    @Published private(set) var isInSession = false
    @Published private(set) var isFinished = false
    @Published private(set) var questionsAnswered = 0
    @Published private(set) var totalQuestions = 10
    @Published private(set) var direction: QuizDirection = .sourceToTarget
    
    func startSession(totalQuestions: Int, direction: QuizDirection) {
        self.totalQuestions = totalQuestions
        self.direction = direction
        UserDefaults.standard.set(totalQuestions, forKey: lastQuestionCountKey)
        UserDefaults.standard.set(direction.rawValue, forKey: lastDirectionKey)

        score = 0
        questionsAnswered = 0
        isFinished = false
        isInSession = true

        selectedAnswer = nil
        showFeedback = false

        nextQuestion()
    }
    
    // Reset game state while keeping current category and settings.
    // Used when user taps "New Game".
    func resetForNewGame() {
        // Fully restart session with existing parameters
        // Ensures a fresh quiz even if category hasn't changed
        startSession(totalQuestions: totalQuestions, direction: direction)
    }
    
    func nextQuestion() {
        guard isInSession else { return }

        if questionsAnswered >= totalQuestions {
            isFinished = true
            isInSession = false
            currentItem = nil
            currentChoices = []
            return
        }

        guard !items.isEmpty else {
            currentItem = nil
            return
        }

        selectedAnswer = nil
        showFeedback = false
        currentItem = items.randomElement()

        // Generate static answer choices for this question (no reshuffling later)
        if let current = currentItem {
            let distractors = items
                .filter { $0.id != current.id }
                .shuffled()
                .prefix(3)

            currentChoices = ([current] + distractors).shuffled()
        } else {
            currentChoices = []
        }
    }
    
    func selectAnswer(_ item: VocabularyItem) {
        guard let current = currentItem, selectedAnswer == nil else { return }

        selectedAnswer = item
        showFeedback = true

        if item.id == current.id {
            score += 1
        }

        questionsAnswered += 1

        // Do NOT auto-advance. User must tap Next Question.
    }
    
    func promptText() -> String {
        guard let current = currentItem else { return "Loading…" }
        switch direction {
        case .sourceToTarget: return current.source   // show English prompt
        case .targetToSource: return current.target   // show Russian prompt
        }
    }

    func optionText(for item: VocabularyItem) -> String {
        switch direction {
        case .sourceToTarget: return item.target      // answers in Russian
        case .targetToSource: return item.source      // answers in English
        }
    }
    
}

