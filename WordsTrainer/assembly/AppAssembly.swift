//
//  AppAssembly.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import Swinject

final class AppAssembly {
    class var assembler: Assembler {
        return Assembler([
                CommonAssembly(),
                CategoryListAssembly(),
                AddCategoryAssembly(),
                WordListAssembly(),
                WordAssembly(),
                FindWordAssembly(),
                AddWordAssembly(),
                TrainingAssembly(),
                TrainingResultAssembly()
            ])
    }
}
