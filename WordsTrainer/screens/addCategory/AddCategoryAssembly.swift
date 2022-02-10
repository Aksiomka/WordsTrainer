//
//  AddCategoryAssembly.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 12.01.2022.
//

import Swinject

class AddCategoryAssembly: Assembly {
    func build(closePopupCallback: @escaping () -> Void) -> AddCategoryPopup {
        var view = AppAssembly.assembler.resolver.resolve(AddCategoryPopup.self)!
        view.closePopupCallback = closePopupCallback
        return view
    }
    
    func assemble(container: Container) {
        container.register(AddCategoryViewModel.self) { (r) in
            return AddCategoryViewModel(categoryDao: r.resolve(CategoryDao.self)!)
        }
        container.register(AddCategoryPopup.self) { r in
            return AddCategoryPopup(viewModel: r.resolve(AddCategoryViewModel.self)!)
        }
    }
}
