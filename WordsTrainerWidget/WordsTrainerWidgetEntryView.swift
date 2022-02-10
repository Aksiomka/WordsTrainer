//
//  WordsTrainerWidgetEntryView.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 21.01.2022.
//

import SwiftUI
import WidgetKit

struct WordsTrainerWidgetEntryView : View {
    @ObservedObject var viewModel: WordsTrainerWidgetViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if viewModel.word.word.isEmpty {
                Text("An error occured: word cannot be loaded")
                    .font(Font.system(size: 16))
                    .foregroundColor(Color.asset.grayText)
            } else {
                Text(viewModel.word.word)
                    .font(Font.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                if !viewModel.word.phonetic.isEmpty || !viewModel.word.partOfSpeech.isEmpty {
                    HStack {
                        Text(viewModel.word.phonetic)
                            .font(Font.system(size: 12))
                            .foregroundColor(Color.asset.grayText)
                        Spacer()
                        Text(viewModel.word.partOfSpeech)
                            .font(Font.system(size: 12))
                            .foregroundColor(Color.asset.grayText)
                    }
                    .frame(maxWidth: .infinity)
                }
                Text(viewModel.word.definition)
                    .font(Font.system(size: 14))
                if !viewModel.word.synonyms.isEmpty {
                    Text("Example: \(viewModel.word.example)")
                        .font(Font.system(size: 12))
                        .foregroundColor(Color.asset.example)
                }
                if !viewModel.word.synonyms.isEmpty {
                    Text("Synonyms: \(viewModel.word.synonyms)")
                        .font(Font.system(size: 10))
                        .foregroundColor(Color.asset.grayText)
                        .lineLimit(1)
                }
                Spacer()
            }
        }.padding()
    }
}

struct WordsTrainerWidgetEntryView_Preview: PreviewProvider {
    static var previews: some View {
        WordsTrainerWidgetEntryView(
            viewModel: WordsTrainerWidgetViewModel(date: Date(), word: WordsTrainerWidgetProvider.sampleWord)
        ).previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
