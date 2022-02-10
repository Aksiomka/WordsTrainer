//
//  WordListAssembly.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import Swinject

class WordListAssembly: Assembly {
    func build(categoryId: Int) -> WordListView {
        return AppAssembly.assembler.resolver.resolve(WordListView.self, argument: categoryId)!
    }
    
    func assemble(container: Container) {
        container.register(WordListViewModel.self) { (r, categoryId: Int) in
            return WordListViewModel(
                categoryId: categoryId,
                wordDao: r.resolve(WordDao.self)!,
                wordListSettingsStorage: r.resolve(WordListSettingsStorage.self)!,
                trainingSettingsStorage: r.resolve(TrainingSettingsStorage.self)!
            )
        }
        container.register(WordListView.self) { (r, categoryId: Int) in
            return WordListView(viewModel: r.resolve(WordListViewModel.self, argument: categoryId)!)
        }
    }
}
