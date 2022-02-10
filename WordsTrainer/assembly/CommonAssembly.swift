//
//  CommonAssembly.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import Swinject

public class CommonAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(RandomGenerator.self) { _ in RandomGenerator() }
        container.register(TrainingInfoMaker.self) { r in
            return TrainingInfoMaker(randomGenerator: r.resolve(RandomGenerator.self)!)
        }
        container.register(WordDao.self) { _ in WordDao() }
        container.register(CategoryDao.self) { _ in CategoryDao() }
        container.register(WordListSettingsStorage.self) { _ in WordListSettingsStorage() }
        container.register(TrainingSettingsStorage.self) { _ in TrainingSettingsStorage() }
        container.register(WordsService.self) { _ in WordsService() }
    }
}
