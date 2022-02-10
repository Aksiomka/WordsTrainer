//
//  TrainingType.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import Foundation

enum TrainingType {
    case learningAll
    case learning(categoryId: Int?)
    case revisingAll
    case revising(categoryId: Int?)
}
