//
//  WordAssembly.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 19.01.2022.
//

import Swinject

class WordAssembly: Assembly {
    func build(wordId: Int) -> WordView {
        return AppAssembly.assembler.resolver.resolve(WordView.self, argument: wordId)!
    }
    
    func assemble(container: Container) {
        container.register(WordViewModel.self) { (r, wordId: Int) in
            return WordViewModel(
                wordId: wordId,
                categoryDao: r.resolve(CategoryDao.self)!,
                wordDao: r.resolve(WordDao.self)!,
                trainingSettingsStorage: r.resolve(TrainingSettingsStorage.self)!
            )
        }
        container.register(WordView.self) { (r, wordId: Int) in
            return WordView(viewModel: r.resolve(WordViewModel.self, argument: wordId)!)
        }
    }
}
