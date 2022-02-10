//
//  WordsTrainerWidget.swift
//  WordsTrainerWidget
//
//  Created by Svetlana Gladysheva on 21.01.2022.
//

import WidgetKit
import SwiftUI

@main
struct WordsTrainerWidget: Widget {
    let kind: String = "WordsTrainerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WordsTrainerWidgetProvider()) { entry in
            WordsTrainerWidgetEntryView(viewModel: entry)
        }
        .configurationDisplayName("Words Trainer Widget")
        .description("This is a widget which shows one word, its definition, usage example and some other information")
    }
}

struct WordsTrainerWidget_Previews: PreviewProvider {
    static var previews: some View {
        WordsTrainerWidgetEntryView(
            viewModel: WordsTrainerWidgetViewModel(date: Date(), word: WordsTrainerWidgetProvider.sampleWord)
        ).previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
