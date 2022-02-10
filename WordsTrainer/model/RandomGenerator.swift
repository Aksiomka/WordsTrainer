//
//  RandomGenerator.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 25.01.2022.
//

import Foundation

protocol RandomGeneratorProtocol {
    func getRandomInt(maxInt: Int) -> Int
}

class RandomGenerator: RandomGeneratorProtocol {
    func getRandomInt(maxInt: Int) -> Int {
        Int.random(in: 0 ... maxInt)
    }
}
