//
//  CategoryListAssembly.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import Swinject

class CategoryListAssembly: Assembly {
    func build() -> CategoryListView {
        return AppAssembly.assembler.resolver.resolve(CategoryListView.self)!
    }
    
    func assemble(container: Container) {
        container.register(CategoryListViewModel.self) { (r) in
            return CategoryListViewModel(
                categoryDao: r.resolve(CategoryDao.self)!,
                wordDao: r.resolve(WordDao.self)!,
                trainingSettingsStorage: r.resolve(TrainingSettingsStorage.self)!
            )
        }
        container.register(CategoryListView.self) { r in
            return CategoryListView(viewModel: r.resolve(CategoryListViewModel.self)!)
        }
    }
}
