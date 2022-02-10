//
//  UserDefaults+Extension.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 28.01.2022.
//

import Foundation

extension UserDefaults {
    static func getShared() -> UserDefaults {
        return UserDefaults(suiteName: "group.ru.gladyshevasm.wordstrainer")!
    }
}
