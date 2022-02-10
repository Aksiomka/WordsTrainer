//
//  MockWordListSettingsStorage.swift
//  WordsTrainerTests
//
//  Created by Svetlana Gladysheva on 27.01.2022.
//

import Foundation
@testable import WordsTrainer

class MockWordListSettingsStorage: WordListSettingsStorageProtocol {
    private var sorting: Sorting
    private var filter: Filter
    
    var savedSorting: Sorting?
    var savedFilter: Filter?
    
    init(sorting: Sorting, filter: Filter) {
        self.sorting = sorting
        self.filter = filter
    }
    
    func saveSorting(_ sorting: Sorting) {
        savedSorting = sorting
        self.sorting = sorting
    }
    
    func loadSorting() -> Sorting {
        return sorting
    }
    
    func saveFilter(_ filter: Filter) {
        savedFilter = filter
        self.filter = filter
    }
    
    func loadFilter() -> Filter {
        return filter
    }
}
