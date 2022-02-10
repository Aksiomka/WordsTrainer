//
//  LearningProgressView.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 24.01.2022.
//

import SwiftUI

struct LearningProgressView: View {
    @Binding var learningProgressPercent: Int
    
    var body: some View {
        HStack {
            Text("Learning progress")
                .font(Font.system(size: 14))
            GeometryReader { metrics in
                ZStack(alignment: .leading) {
                    Color.white
                        .border(Color.asset.blue)
                    Color.asset.blue
                        .frame(width: metrics.size.width * CGFloat(learningProgressPercent) / 100)
                    Text("\(learningProgressPercent)%")
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}
