//
//  Image+Extension.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 08.02.2022.
//

import SwiftUI

extension Image {
    static let asset = Image.Asset()
    
    struct Asset {
        let plus = Image(systemName: "plus")
        let rightArrow = Image(systemName: "arrow.right")
        let play = Image(systemName: "play.circle")
        let sortAlphabetically = Image(systemName: "textformat")
        let sortByProgress = Image(systemName: "person.fill.checkmark")
        let learning = Image(systemName: "doc.text.below.ecg")
        let training = Image(systemName: "arrow.triangle.2.circlepath.doc.on.clipboard")
    }
}
