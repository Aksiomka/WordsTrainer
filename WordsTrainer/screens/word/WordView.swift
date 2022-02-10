//
//  WordView.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 19.01.2022.
//

import SwiftUI

struct WordView: View {
    @ObservedObject var viewModel: WordViewModel
    
    var body: some View {
        return ZStack{
            VStack(alignment: .leading) {
                Text(viewModel.word.word)
                    .frame(maxWidth: .infinity)
                    .font(Font.system(size: 20, weight: .semibold))
                Text("Category: \(viewModel.categoryName)")
                HStack {
                    if !viewModel.word.phonetic.isEmpty {
                        Text(viewModel.word.phonetic)
                            .font(Font.system(size: 14))
                            .foregroundColor(Color.asset.grayText)
                    }
                    Button(action: {
                        viewModel.playSound()
                    }, label: {
                        Image.asset.play
                    })
                    Spacer()
                    if !viewModel.word.phonetic.isEmpty {
                        Text(viewModel.word.partOfSpeech)
                            .font(Font.system(size: 14))
                    }
                }
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                Text(viewModel.word.definition)
                if !viewModel.word.example.isEmpty {
                    Text("Example: \(viewModel.word.example)")
                        .font(Font.system(size: 15))
                        .foregroundColor(Color.asset.example)
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                }
                if !viewModel.word.synonyms.isEmpty {
                    Text("Synonyms: \(viewModel.word.synonyms)")
                        .font(Font.system(size: 14))
                        .foregroundColor(Color.asset.grayText)
                }
                LearningProgressView(learningProgressPercent: $viewModel.learningProgressPercent)
                    .frame(height: 30)
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0))
                Spacer()
            }
            .padding()
        }
        .onAppear(perform: viewModel.loadData)
        .navigationBarTitle(Text("Word"), displayMode: .inline)
    }
}

struct WordView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = WordViewModel(
            wordId: 0,
            categoryDao: CategoryDao(),
            wordDao: WordDao(),
            trainingSettingsStorage: TrainingSettingsStorage()
        )
        return WordView(viewModel: viewModel)
    }
}
