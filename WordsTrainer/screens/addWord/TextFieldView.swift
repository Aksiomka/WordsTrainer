//
//  TextFieldView.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 24.01.2022.
//

import SwiftUI

struct TextFieldView: View {
    @Binding var text: String
    var name: String
    
    var body: some View {
        return VStack(alignment: .leading) {
            Text(name)
                .font(Font.system(size: 12))
            TextField(name, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}
