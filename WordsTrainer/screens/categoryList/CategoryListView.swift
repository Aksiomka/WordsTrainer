//
//  CategoryListView.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import SwiftUI

struct CategoryListView: View {
    @ObservedObject var viewModel: CategoryListViewModel
    @StateObject var appViewData = AppViewData()
    
    @State private var showingDeleteAlert = false
    @State private var indexSetToDelete: IndexSet?
    @State private var showingAddCategoryPopup = false
    @State private var showingCannotStartTrainingAlert = false
    @State private var showingCannotStartRevisingAlert = false
    
    private static var wordListViewsMap = [Int: WordListView]()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    if !viewModel.categories.isEmpty {
                        List {
                            ForEach(viewModel.categories, id: \.id) { category in
                                NavigationLink(destination: getWordListView(categoryId: category.id)) {
                                    CategoryRow(category: category)
                                }
                            }.onDelete(perform: { indexSet in
                                indexSetToDelete = indexSet
                                showingDeleteAlert = true
                            })
                        }
                        .alert(isPresented: $showingDeleteAlert) {
                            let indexSet = indexSetToDelete!
                            return Alert(
                                title: Text("Confirmation"),
                                message: Text("Are you sure you want to delete this category?"),
                                primaryButton: .cancel(),
                                secondaryButton: .destructive(Text("Delete")) {
                                    deleteCategories(at: indexSet)
                                }
                            )
                        }
                    } else {
                        Spacer()
                        Text("There are no categories")
                            .foregroundColor(Color.asset.grayText)
                            .padding()
                        Spacer()
                    }
                    VStack {
                        Spacer().frame(height: 8)
                        StartTrainingButtonView(
                            trainingType: .learningAll,
                            navigationTag: getLearningNavigationTag(),
                            startTrainingButtonDisabled: $viewModel.startTrainingButtonDisabled,
                            showingCannotStartTrainingAlert: $showingCannotStartTrainingAlert
                        )
                        StartTrainingButtonView(
                            trainingType: .revisingAll,
                            navigationTag: getRevisingNavigationTag(),
                            startTrainingButtonDisabled: $viewModel.startRevisingButtonDisabled,
                            showingCannotStartTrainingAlert: $showingCannotStartRevisingAlert
                        )
                    }
                    .background(Color.asset.grayBg)
                    .padding(EdgeInsets(top: 1, leading: 0, bottom: 0, trailing: 0))
                    .background(Color.asset.separator)
                    NavigationLink(
                        tag: getLearningNavigationTag(),
                        selection: $appViewData.trainingNavigationSelection,
                        destination: { TrainingAssembly().build(trainingType: .learningAll) }
                    ) {
                        EmptyView()
                    }
                    NavigationLink(
                        tag: getRevisingNavigationTag(),
                        selection: $appViewData.trainingNavigationSelection,
                        destination: { TrainingAssembly().build(trainingType: .revisingAll) }
                    ) {
                        EmptyView()
                    }
                }
                if showingAddCategoryPopup {
                    AddCategoryAssembly().build(closePopupCallback: {
                        showingAddCategoryPopup = false
                    })
                }
            }
            .onAppear(perform: viewModel.onAppear)
            .onDisappear(perform: viewModel.onDisappear)
            .navigationBarTitle(Text("Categories"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddCategoryPopup = true
                    }) {
                        Image.asset.plus
                    }
                }
            }
        }
        .animation(.easeInOut, value: showingAddCategoryPopup)
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(appViewData)
    }
    
    private func getLearningNavigationTag() -> String { "learningAll" }
    private func getRevisingNavigationTag() -> String { "revisingAll" }
    
    private func deleteCategories(at offsets: IndexSet) {
        viewModel.deleteCategories(indexes: offsets)
    }
    
    private func getWordListView(categoryId: Int) -> WordListView {
        if let view = Self.wordListViewsMap[categoryId] {
            return view
        }

        let wordListView = WordListAssembly().build(categoryId: categoryId)
        Self.wordListViewsMap[categoryId] = wordListView
        return wordListView
    }
}

struct CategoryList_Previews: PreviewProvider {
    static var previews: some View {
        let categories = [
            Category(id: 1, name: "Food"),
            Category(id: 2, name: "Weather"),
            Category(id: 3, name: "Work")
        ]
        let viewModel = CategoryListViewModel(
            categoryDao: CategoryDao(),
            wordDao: WordDao(),
            trainingSettingsStorage: TrainingSettingsStorage()
        )
        viewModel.categories = categories
        return CategoryListView(viewModel: viewModel)
    }
}
