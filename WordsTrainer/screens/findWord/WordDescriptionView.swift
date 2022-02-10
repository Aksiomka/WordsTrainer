//
//  WordDescriptionView.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 15.01.2022.
//

import SwiftUI

struct WordDescriptionView : View {
    var word: WordDescription

    var body: some View {
        VStack(alignment: .leading) {
            Text(word.word)
                .font(Font.system(size: 17, weight: .bold))
            if word.phonetic != "" {
                Text(word.phonetic)
                    .font(Font.system(size: 12))
                    .foregroundColor(Color.asset.grayText)
            }
            Text(word.definition)
                .font(Font.system(size: 14))
            if word.partOfSpeech != "" {
                Text(word.partOfSpeech)
                    .font(Font.system(size: 12))
                    .foregroundColor(Color.asset.grayText)
                }
            if word.example != "" {
                Text("Example: \(word.example)")
                    .font(Font.system(size: 13))
                    .foregroundColor(Color.asset.example)
            }
            if !word.synonyms.isEmpty {
                Text("Synonyms: \(word.synonyms.joined(separator: ", "))")
                    .font(Font.system(size: 12))
                    .foregroundColor(Color.asset.grayText)
            }
        }
    }
}

struct WordDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        WordDescriptionView(
            word: WordDescription(
                word: "word",
                phonetic: "word",
                partOfSpeech: "noun",
                definition: "A unit of speech which is used to express your thoughts when you are talking",
                example: "Say a word",
                synonyms: ["name", "word"]
            )
        )
    }
}
