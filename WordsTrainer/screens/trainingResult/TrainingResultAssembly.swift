//
//  TrainingResultAssembly.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import Foundation
import Swinject

class TrainingResultAssembly: Assembly {
    func build(trainingResult: TrainingResult) -> TrainingResultView {
        return AppAssembly.assembler.resolver.resolve(TrainingResultView.self, argument: trainingResult)!
    }
    
    func assemble(container: Container) {
        container.register(TrainingResultViewModel.self) { (r, trainingResult: TrainingResult) in
            return TrainingResultViewModel(
                trainingResult: trainingResult,
                wordDao: r.resolve(WordDao.self)!,
                trainingSettingsStorage: r.resolve(TrainingSettingsStorage.self)!
            )
        }
        container.register(TrainingResultView.self) { (r, trainingResult: TrainingResult) in
            return TrainingResultView(viewModel: r.resolve(TrainingResultViewModel.self, argument: trainingResult)!)
        }
    }
}
