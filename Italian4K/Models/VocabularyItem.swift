//
//  VocabularyItem.swift
//  Italian4K
//
//  Created by WARREN PETERS on 17/02/2026.
//

import Foundation

struct VocabularyItem: Codable, Identifiable {
    let id = UUID()
    let source: String
    let target: String
}
