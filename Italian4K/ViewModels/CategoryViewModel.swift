//
//  CategoryViewModel.swift
//  Italian4K
//
//  Created by WARREN PETERS on 17/02/2026.
//

import Foundation

import Combine

struct Category: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let fileNames: [String]
    let isPremium: Bool
}

final class CategoryViewModel: ObservableObject {
    
    @Published var categories: [Category] = [
        Category(title: "Animals", fileNames: ["animals"], isPremium: false),
        Category(title: "Food", fileNames: ["food"], isPremium: false),
        Category(title: "Clothing", fileNames: ["clothing"], isPremium: false),
        Category(title: "Family", fileNames: ["family"], isPremium: false),
        Category(title: "House", fileNames: ["house"], isPremium: false),
        Category(title: "Phrases", fileNames: ["phrases"], isPremium: false),
        Category(title: "Adjectives", fileNames: ["adjectives"], isPremium: true),
        Category(title: "Body", fileNames: ["body"], isPremium: true),
        Category(title: "Collocations", fileNames: ["collocations"], isPremium: true),
        Category(title: "Conjugationed Verbs", fileNames: ["conjugations"], isPremium: true),
        Category(title: "Colors", fileNames: ["colours"], isPremium: true),
        Category(title: "Education", fileNames: ["education"], isPremium: true),
        Category(title: "Jobs", fileNames: ["jobs"], isPremium: true),
        Category(title: "Office", fileNames: ["office"], isPremium: false),
        Category(title: "Music", fileNames: ["music"], isPremium: true),
        Category(title: "Numbers", fileNames: ["numbers"], isPremium: true),
        Category(title: "Personality", fileNames: ["personality"], isPremium: true),
        Category(title: "Time", fileNames: ["time"], isPremium: true),
        Category(title: "Transport", fileNames: ["transport"], isPremium: true),
        Category(title: "Verbs", fileNames: ["verbs"], isPremium: true),
        Category(title: "Weather", fileNames: ["weather"], isPremium: true),
        Category(title: "Core Words", fileNames: ["core"], isPremium: true)
    ]
    
    @Published var selectedCategory: Category?
    
    func canAccess(_ category: Category) -> Bool {
        // TEMP TESTING: allow access to all categories (including premium)
        // Restore real paywall logic later
        return true
    }
}



