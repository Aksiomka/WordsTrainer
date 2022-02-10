//
//  FindWordView.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 16.01.2022.
//

import SwiftUI

struct FindWordView: View {
    @ObservedObject var viewModel: FindWordViewModel
    @EnvironmentObject var appViewData: AppViewData
    
    var body: some View {
        VStack {
            HStack {
                TextField("Word", text: $viewModel.word)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 8))
                Button(action: {
                    viewModel.findWord()
                }) {
                    Text("Find")
                        .frame(width: 48, height: 32)
                        .background(viewModel.findButtonDisabled || viewModel.loading ? Color.asset.disabled : Color.asset.blue)
                        .foregroundColor(Color.white)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                }
                .disabled(viewModel.findButtonDisabled || viewModel.loading)
            }
            Spacer()
            ZStack {
                List {
                    ForEach(viewModel.wordDescriptions, id: \.self) { wordDescription in
                        NavigationLink(
                            destination: AddWordAssembly().build(categoryId: viewModel.categoryId, wordDescription: wordDescription)
                        ) {
                            WordDescriptionView(word: wordDescription)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                if viewModel.loading {
                    ProgressView()
                }
                if viewModel.errorOccured {
                    Text("An error occured while loading data.\nMaybe there is no such word.")
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
        }
        .navigationBarTitle(Text("Add word"), displayMode: .inline)
    }
}

struct FindWordView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = FindWordViewModel(categoryId: 0, wordsService: WordsService())
        return FindWordView(viewModel: viewModel)
    }
}
