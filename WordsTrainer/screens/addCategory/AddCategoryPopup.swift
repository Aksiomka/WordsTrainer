//
//  AddCategoryPopup.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 12.01.2022.
//

import SwiftUI

struct AddCategoryPopup: View {
    @ObservedObject var viewModel: AddCategoryViewModel
    
    var closePopupCallback: () -> Void = {}
    
    var body: some View {
        ZStack{
            Rectangle()
            .fill(Color.gray)
            .opacity(0.5)
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                closePopupCallback()
            }

            VStack {
                Text("Add category")
                    .frame(width: 300, height: 50, alignment: .center)
                    .background(Color.asset.popupAccent)
                    .foregroundColor(Color.white)
                Spacer()
                TextField("Category name", text: $viewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                Spacer()
                HStack {
                    Spacer().frame(width: 16)
                    Button(action: {
                        closePopupCallback()
                    }) {
                        Text("Cancel")
                            .frame(width: 120, height: 40, alignment: .center)
                            .background(Color.asset.cancel)
                            .foregroundColor(Color.white)
                            .cornerRadius(12)
                    }
                    Spacer()
                    Button(action: {
                        viewModel.saveCategory()
                        closePopupCallback()
                    }) {
                        Text("Save")
                        .frame(width: 120, height: 40, alignment: .center)
                        .background(viewModel.saveButtonDisabled ? Color.asset.disabled : Color.asset.popupAccent)
                        .foregroundColor(Color.white)
                        .cornerRadius(12)
                    }
                    .disabled(viewModel.saveButtonDisabled)
                    Spacer().frame(width: 16)
                }
                Spacer()
            }
            .frame(minWidth: 300, idealWidth: 300, maxWidth: 300, minHeight: 250, idealHeight: 250, maxHeight: 250, alignment: .top)
            .fixedSize(horizontal: true, vertical: true)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 5)
        }
    }
}

struct AddCategoryPopup_Previews: PreviewProvider {
    static var previews: some View {
        let categoryDao = CategoryDao()
        let viewModel = AddCategoryViewModel(categoryDao: categoryDao)
        return AddCategoryPopup(viewModel: viewModel)
    }
}
