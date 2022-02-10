//
//  AddWordAssembly.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import Swinject

class AddWordAssembly: Assembly {
    func build(categoryId: Int, wordDescription: WordDescription) -> AddWordView {
        return AppAssembly.assembler.resolver.resolve(AddWordView.self, arguments: categoryId, wordDescription)!
    }
    
    func assemble(container: Container) {
        container.register(AddWordViewModel.self) { (r, categoryId: Int, wordDescription: WordDescription) in
            return AddWordViewModel(
                categoryId: categoryId,
                wordDescription: wordDescription,
                wordDao: r.resolve(WordDao.self)!
            )
        }
        container.register(AddWordView.self) { (r, categoryId: Int, wordDescription: WordDescription) in
            return AddWordView(viewModel: r.resolve(AddWordViewModel.self, arguments: categoryId, wordDescription)!)
        }
    }
}
