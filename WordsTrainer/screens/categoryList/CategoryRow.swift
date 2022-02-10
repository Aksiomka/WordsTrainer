//
//  CategoryRow.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import SwiftUI

struct CategoryRow : View {
    var category: Category

    var body: some View {
        Text(category.name)
            .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
    }
}

struct CategoryRow_Previews: PreviewProvider {
    static var previews: some View {
        CategoryRow(category: Category(id: 1, name: "Food"))
    }
}
