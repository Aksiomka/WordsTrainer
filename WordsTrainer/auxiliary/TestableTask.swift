//
//  TestableTask.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 04.02.2022.
//

import Foundation

class TestableTask {
    static func task(operation: @escaping () async -> Void, completion: (() -> Void)? = nil) {
        Task {
            await operation()
            completion?()
        }
    }
}
