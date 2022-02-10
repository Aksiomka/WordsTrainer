//
//  TrainingResultView.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import SwiftUI

struct TrainingResultView: View {
    @ObservedObject var viewModel: TrainingResultViewModel
    @EnvironmentObject var appViewData: AppViewData
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer().frame(height: 8)
                Text("Right answers: \(viewModel.rightAnswers)")
                Text("Wrong answers: \(viewModel.wrongAnswers)")
                List {
                    ForEach(viewModel.words, id: \.id) { word in
                        WordRow(wordModel: word)
                    }
                }
                .listStyle(PlainListStyle())
                Button(action: {
                    appViewData.trainingNavigationSelection = nil
                }, label: {
                    Text("OK")
                        .modifier(TrainingButtonStyle(buttonDisabled: Binding.constant(false)))
                })
            }
        }
        .navigationBarTitle(Text("Training Results"), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: viewModel.loadWords)
    }
}

struct TrainingResultView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = TrainingResultViewModel(
            trainingResult: TrainingResult(wordIds: [], numberOfRightAnswers: 0),
            wordDao: WordDao(),
            trainingSettingsStorage: TrainingSettingsStorage()
        )
        return TrainingResultView(viewModel: viewModel)
    }
}
