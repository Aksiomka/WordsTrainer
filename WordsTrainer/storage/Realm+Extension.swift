//
//  Realm+Extension.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 22.01.2022.
//

import Foundation
import RealmSwift

extension Realm {
    static func getInstance() -> Realm {
        let fileURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.ru.gladyshevasm.words_trainer")!
            .appendingPathComponent("default.realm")
        let config = Realm.Configuration(fileURL: fileURL)
        return try! Realm(configuration: config)
    }
}
