//
//  AddWordView.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import SwiftUI

struct AddWordView: View {
    @ObservedObject var viewModel: AddWordViewModel
    @EnvironmentObject var appViewData: AppViewData
    
    var body: some View {
        return ZStack{
            ScrollView{
                VStack(alignment: .leading) {
                    TextField("Word", text: $viewModel.word).textFieldStyle(RoundedBorderTextFieldStyle())
                    TextFieldView(text: $viewModel.phonetic, name: "Phonetic")
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                    TextEditorView(text: $viewModel.definition, name: "Definition")
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                    TextFieldView(text: $viewModel.partOfSpeech, name: "Part of speech")
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                    TextEditorView(text: $viewModel.example, name: "Example")
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                    TextEditorView(text: $viewModel.synonyms, name: "Synonyms")
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                    Spacer().frame(minHeight: 60, maxHeight: .infinity)
                }
                .padding()
            }
            VStack {
                Spacer()
                Button(action: {
                    viewModel.saveWord()
                    appViewData.addWordNavigationSelection = nil
                }) {
                    Text("Save")
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .background(viewModel.saveButtonDisabled ? Color.asset.disabled : Color.asset.blue)
                        .foregroundColor(Color.white)
                }
                .disabled(viewModel.saveButtonDisabled)
                .padding()
            }
        }
        .navigationBarTitle(Text("Add word"), displayMode: .inline)
    }
    
    private func textChanged() {
        viewModel.validate()
    }
}

struct AddWordView_Previews: PreviewProvider {
    static var previews: some View {
        let wordDao = WordDao()
        let viewModel = AddWordViewModel(
            categoryId: 0,
            wordDescription: WordDescription(
                word: "",
                phonetic: "",
                partOfSpeech: "",
                definition: "",
                example: "",
                synonyms: []
            ),
            wordDao: wordDao
        )
        return AddWordView(viewModel: viewModel)
    }
}
