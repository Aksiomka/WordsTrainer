//
//  FindWordViewModel.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 16.01.2022.
//

import Foundation

class FindWordViewModel: ObservableObject {
    @Published var word = "" {
        didSet {
            validate()
        }
    }
    @Published var categoryId: Int
    @Published var findButtonDisabled = true
    @Published var wordDescriptions: [WordDescription] = []
    @Published var loading = false
    @Published var errorOccured = false
    
    var taskCompletionHandler: (() -> Void)? // for testing
    
    private let wordsService: WordsServiceProtocol
    
    init(categoryId: Int, wordsService: WordsServiceProtocol) {
        self.categoryId = categoryId
        self.wordsService = wordsService
    }
    
    func validate() {
        let valid = word.trimmingCharacters(in: .whitespacesAndNewlines) != ""
        findButtonDisabled = !valid
    }
    
    func findWord() {
        wordDescriptions = []
        loading = true
        errorOccured = false
        
        TestableTask.task(operation: { [weak self] in
            guard let self = self else { return }
            do {
                let wordModel = try await self.wordsService.getWordDescription(word: self.word)
                let wordDescriptions = self.convertWordModel(wordModel)
                
                await MainActor.run {
                    self.wordDescriptions = wordDescriptions
                    self.loading = false
                }
            } catch {
                await MainActor.run {
                    self.loading = false
                    self.errorOccured = true
                }
            }
        }, completion: { [weak self] in
            self?.taskCompletionHandler?()
        })
    }
}

private extension FindWordViewModel {
    func convertWordModel(_ wordModel: [WordApiModel]) -> [WordDescription] {
        var result: [WordDescription] = []
        for model in wordModel {
            for meaning in model.meanings {
                for definition in meaning.definitions {
                    let wordDescription = WordDescription(
                        word: model.word,
                        phonetic: model.phonetics.first?.text ?? "",
                        partOfSpeech: meaning.partOfSpeech ?? "",
                        definition: definition.definition ?? "",
                        example: definition.example ?? "",
                        synonyms: definition.synonyms
                    )
                    result.append(wordDescription)
                }
            }
        }
        return result
    }
}
