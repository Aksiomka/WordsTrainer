//
//  TrainingAssembly.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import Swinject

class TrainingAssembly: Assembly {
    func build(trainingType: TrainingType) -> TrainingView {
        return AppAssembly.assembler.resolver.resolve(TrainingView.self, argument: trainingType)!
    }
    
    func assemble(container: Container) {
        container.register(TrainingViewModel.self) { (r, trainingType: TrainingType) in
            return TrainingViewModel(
                trainingType: trainingType,
                wordDao: r.resolve(WordDao.self)!,
                trainingInfoMaker: r.resolve(TrainingInfoMaker.self)!,
                trainingSettingsStorage: r.resolve(TrainingSettingsStorage.self)!)
        }
        container.register(TrainingView.self) { (r, trainingType: TrainingType) in
            return TrainingView(viewModel: r.resolve(TrainingViewModel.self, argument: trainingType)!)
        }
    }
}
