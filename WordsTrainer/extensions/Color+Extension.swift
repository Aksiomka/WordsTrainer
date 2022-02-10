//
//  Color+Extension.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 22.01.2022.
//

import SwiftUI

extension Color {
    static let asset = Color.Asset()
    
    struct Asset {
        let right = Color("right")
        let wrong = Color("wrong")
        let learned = Color("learned")
        let halfLearned = Color("halfLearned")
        let new = Color("new")
        let example = Color("example")
        let disabled = Color("disabled")
        let separator = Color("separator")
        let popupAccent = Color("popupAccent")
        let cancel = Color("cancel")
        let grayText = Color("grayText")
        let grayBg = Color("grayBg")
        let blue = Color("blue")
    }
}
