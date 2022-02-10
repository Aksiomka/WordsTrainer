//
//  FindWordAssembly.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 16.01.2022.
//

import Swinject

class FindWordAssembly: Assembly {
    func build(categoryId: Int) -> FindWordView {
        return AppAssembly.assembler.resolver.resolve(FindWordView.self, argument: categoryId)!
    }
    
    func assemble(container: Container) {
        container.register(FindWordViewModel.self) { (r, categoryId: Int) in
            return FindWordViewModel(categoryId: categoryId, wordsService: r.resolve(WordsService.self)!)
        }
        container.register(FindWordView.self) { (r, categoryId: Int) in
            return FindWordView(viewModel: r.resolve(FindWordViewModel.self, argument: categoryId)!)
        }
    }
}
