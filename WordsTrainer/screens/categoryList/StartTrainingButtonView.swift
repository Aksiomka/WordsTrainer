//
//  StartTrainingButtonView.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 24.01.2022.
//

import SwiftUI

struct StartTrainingButtonView: View {
    var trainingType: TrainingType
    var navigationTag: String
    @Binding var startTrainingButtonDisabled: Bool
    @Binding var showingCannotStartTrainingAlert: Bool
    @EnvironmentObject var appViewData: AppViewData
    
    var body: some View {
        VStack {
            Button(action: {
                if startTrainingButtonDisabled {
                    showingCannotStartTrainingAlert = true
                } else {
                    appViewData.trainingNavigationSelection = navigationTag
                }
            }, label: {
                HStack {
                    buttonImage
                    Spacer().frame(width: 8)
                    Text(buttonText)
                }
                .frame(height: 32)
                .frame(maxWidth: .infinity)
            })
                .alert(isPresented: $showingCannotStartTrainingAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
        }
    }
    
    private var buttonImage: Image {
        switch trainingType {
        case .learningAll, .learning:
            return Image.asset.training
        case .revisingAll, .revising:
            return Image.asset.learning
        }
    }
    
    private var buttonText: String {
        switch trainingType {
        case .learningAll, .learning:
            return "Train words"
        case .revisingAll, .revising:
            return "Revise learned words"
        }
    }
    
    private var alertTitle: String {
        switch trainingType {
        case .learningAll, .learning:
            return "Cannot start training"
        case .revisingAll, .revising:
            return "Cannot start revising"
        }
    }
    
    private var alertMessage: String {
        switch trainingType {
        case .learningAll, .learning:
            return "Add more words"
        case .revisingAll, .revising:
            return "Learn more words"
        }
    }
}
