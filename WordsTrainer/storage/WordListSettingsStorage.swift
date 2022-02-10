//
//  WordListSettingsStorage.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import Foundation

protocol WordListSettingsStorageProtocol {
    func saveSorting(_ sorting: Sorting)
    func loadSorting() -> Sorting
    func saveFilter(_ filter: Filter)
    func loadFilter() -> Filter
}

class WordListSettingsStorage: WordListSettingsStorageProtocol {
    private let sortingKey = "sorting"
    private let filterKey = "filter"
    
    func saveSorting(_ sorting: Sorting) {
        UserDefaults.getShared().set(sorting.rawValue, forKey: sortingKey)
    }
    
    func loadSorting() -> Sorting {
        let sortingStr = UserDefaults.getShared().string(forKey: sortingKey) ?? ""
        return Sorting(rawValue: sortingStr) ?? .alphabetically
    }
    
    func saveFilter(_ filter: Filter) {
        UserDefaults.getShared().set(filter.rawValue, forKey: filterKey)
    }
    
    func loadFilter() -> Filter {
        let filterStr = UserDefaults.getShared().string(forKey: filterKey) ?? ""
        return Filter(rawValue: filterStr) ?? .all
    }
}
