//
//  WordRow.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import SwiftUI

struct WordRow : View {
    var wordModel: WordRowInfo

    var body: some View {
        HStack {
            Circle()
                .fill(getCircleColor())
                .frame(width: 20, height: 20)
            VStack(alignment: .leading) {
                Text(wordModel.word)
                Text(wordModel.definition)
                    .font(Font.system(size: 12))
                    .foregroundColor(Color.asset.grayText)
            }
        }.padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
    }
    
    private func getCircleColor() -> Color {
        switch wordModel.wordStatus {
        case .learned:
            return Color.asset.learned
        case .halfLearned:
            return Color.asset.halfLearned
        case .new:
            return Color.asset.new
        }
    }
}

struct WordRow_Previews: PreviewProvider {
    static var previews: some View {
        WordRow(
            wordModel: WordRowInfo(
                id: 0,
                word: "word",
                definition: "consists of letters",
                wordStatus: .new
            )
        )
    }
}
