//
//  DataLoader.swift
//  Italian4K
//
//  Created by WARREN PETERS on 17/02/2026.
//

import Foundation

class DataLoader {
    
    static func loadVocabulary(from fileName: String) -> [VocabularyItem] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("JSON file not found")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([VocabularyItem].self, from: data)
            return decoded
        } catch {
            print("Error decoding JSON:", error)
            return []
        }
    }
}
