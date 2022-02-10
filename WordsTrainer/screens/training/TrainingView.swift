//
//  TrainingView.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import SwiftUI

struct TrainingView: View {
    @ObservedObject var viewModel: TrainingViewModel
    @EnvironmentObject var appViewData: AppViewData
    @State var trainingResultNavigationLinkActive = false
    
    var body: some View {
        VStack {
            VStack {
                Spacer().frame(height: 32)
                Text("Task \(viewModel.stepNumber)")
                    .bold()
                Text("Choose the right word")
                    .font(.subheadline)
                    .foregroundColor(Color.asset.example)
                    .padding(EdgeInsets(top: 16, leading: 0, bottom: 40, trailing: 0))
                Text(viewModel.definition)
                    .font(Font.system(size: 14, weight: .semibold))
            }
            Spacer()
            ForEach(viewModel.answers, id: \.self) { answer in
                Button(action: {
                    viewModel.answerChosen(answer: answer)
                }, label: {
                    Text(answer.answer)
                        .frame(width: 200, height: 40, alignment: .center)
                        .background(getAnswerButtonBgColor(answer: answer))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .padding()
                })
                .disabled(viewModel.answerButtonsDisabled)
            }
            Spacer()
            if viewModel.buttonType == .next {
                Button(action: {
                    viewModel.nextTapped()
                }, label: {
                    HStack {
                        Text("Next")
                        Image.asset.rightArrow
                    }.modifier(TrainingButtonStyle(buttonDisabled: $viewModel.nextButtonDisabled))
                })
                .disabled(viewModel.nextButtonDisabled)
            } else {
                Button(action: {
                    trainingResultNavigationLinkActive = true
                }, label: {
                    Text("Finish")
                        .modifier(TrainingButtonStyle(buttonDisabled: $viewModel.nextButtonDisabled))
                })
                .disabled(viewModel.nextButtonDisabled)
            }
            Spacer()
            NavigationLink(
                destination: TrainingResultAssembly().build(trainingResult: viewModel.createTrainingResult()),
                isActive: $trainingResultNavigationLinkActive
            ) {
                EmptyView()
            }
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .navigationBarTitle(Text("Training"), displayMode: .inline)
        .onAppear(perform: viewModel.loadData)
    }
    
    private func getAnswerButtonBgColor(answer: TrainingAnswer) -> Color {
        viewModel.answerButtonsDisabled ? (answer.correct ? Color.asset.right : Color.asset.wrong) : Color.asset.blue
    }
}

struct TrainingButtonStyle: ViewModifier {
    @Binding var buttonDisabled: Bool
    
    func body(content: Content) -> some View {
        content
            .frame(width: 200, height: 40, alignment: .center)
            .background(buttonDisabled ? Color.asset.disabled : Color.asset.blue)
            .foregroundColor(.white)
            .cornerRadius(16)
    }
}

struct TrainingView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = TrainingViewModel(
            trainingType: .learningAll,
            wordDao: WordDao(),
            trainingInfoMaker: TrainingInfoMaker(randomGenerator: RandomGenerator()),
            trainingSettingsStorage: TrainingSettingsStorage()
        )
        viewModel.definition = "word"
        viewModel.answers = [
            TrainingAnswer(answer: "a", correct: false),
            TrainingAnswer(answer: "b", correct: false),
            TrainingAnswer(answer: "c", correct: true),
            TrainingAnswer(answer: "d", correct: false)]
        return TrainingView(viewModel: viewModel)
    }
}
