//
//  TextEditorView.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 24.01.2022.
//

import SwiftUI

struct TextEditorView: View {
    @Binding var text: String
    var name: String
    
    var body: some View {
        return VStack(alignment: .leading) {
            Text(name)
                .font(Font.system(size: 12))
            TextEditor(text: $text)
                .frame(height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary).opacity(0.5)
                )
        }
    }
}
