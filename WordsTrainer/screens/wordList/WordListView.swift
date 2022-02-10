//
//  WordListView.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 11.01.2022.
//

import SwiftUI

struct WordListView: View {
    @ObservedObject var viewModel: WordListViewModel
    @State private var showingDeleteAlert = false
    @State private var indexSetToDelete: IndexSet?
    @EnvironmentObject var appViewData: AppViewData
    
    @State private var showingCannotStartTrainingAlert = false
    @State private var showingCannotStartRevisingAlert = false
    
    private static var findWordViewsMap = [Int: FindWordView]()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    viewModel.onSortingChanged(sorting: .alphabetically)
                }, label: {
                    Image.asset.sortAlphabetically
                })
                Button(action: {
                    viewModel.onSortingChanged(sorting: .byProgress)
                }, label: {
                    Image.asset.sortByProgress
                })
                Spacer()
                Button(action: {
                    viewModel.onFilterChanged(filter: .new)
                }, label: {
                    Circle()
                        .fill(Color.asset.new)
                    .frame(width: 20, height: 20)
                })
                Button(action: {
                    viewModel.onFilterChanged(filter: .halfLearned)
                }, label: {
                    Circle()
                        .fill(Color.asset.halfLearned)
                    .frame(width: 20, height: 20)
                })
                Button(action: {
                    viewModel.onFilterChanged(filter: .learned)
                }, label: {
                    Circle()
                        .fill(Color.asset.learned)
                    .frame(width: 20, height: 20)
                })
                Button(action: {
                    viewModel.onFilterChanged(filter: .all)
                }, label: {
                    Text("All")
                })
            }.padding()
                .background(Color.asset.grayBg)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
                .background(Color.asset.separator)
            if !viewModel.words.isEmpty {
                List {
                    ForEach(viewModel.words, id: \.id) { word in
                        NavigationLink(destination: WordAssembly().build(wordId: word.id)) {
                            WordRow(wordModel: word)
                        }
                    }.onDelete(perform: { indexSet in
                        indexSetToDelete = indexSet
                        showingDeleteAlert = true
                    })
                }
                .listStyle(PlainListStyle())
                .alert(isPresented: $showingDeleteAlert) {
                    let indexSet = indexSetToDelete!
                    return Alert(
                        title: Text("Confirmation"),
                        message: Text("Are you sure you want to delete this word?"),
                        primaryButton: .cancel(),
                        secondaryButton: .destructive(Text("Delete")) {
                            deleteWords(at: indexSet)
                        }
                    )
                }
            } else {
                Spacer()
                Text("There are no words in this category")
                    .foregroundColor(Color.asset.grayText)
                    .padding()
                Spacer()
            }
            VStack {
                Spacer().frame(height: 8)
                StartTrainingButtonView(
                    trainingType: .learning(categoryId: viewModel.categoryId),
                    navigationTag: getTrainingNavigationTag(),
                    startTrainingButtonDisabled: $viewModel.startTrainingButtonDisabled,
                    showingCannotStartTrainingAlert: $showingCannotStartTrainingAlert
                )
                StartTrainingButtonView(
                    trainingType: .revising(categoryId: viewModel.categoryId),
                    navigationTag: getRevisingNavigationTag(),
                    startTrainingButtonDisabled: $viewModel.startRevisingButtonDisabled,
                    showingCannotStartTrainingAlert: $showingCannotStartRevisingAlert
                )
            }
            .background(Color.asset.grayBg)
            .padding(EdgeInsets(top: 1, leading: 0, bottom: 0, trailing: 0))
            .background(Color.asset.separator)
            NavigationLink(
                tag: getTrainingNavigationTag(),
                selection: $appViewData.trainingNavigationSelection,
                destination: { TrainingAssembly().build(trainingType: .learning(categoryId: viewModel.categoryId)) }
            ) {
                EmptyView()
            }
            NavigationLink(
                tag: getRevisingNavigationTag(),
                selection: $appViewData.trainingNavigationSelection,
                destination: { TrainingAssembly().build(trainingType: .revising(categoryId: viewModel.categoryId)) }
            ) {
                EmptyView()
            }
            NavigationLink(
                tag: getAddWordNavigationTag(),
                selection: $appViewData.addWordNavigationSelection,
                destination: { getFindWordView(categoryId: viewModel.categoryId) }
            ) {
                EmptyView()
            }
        }
        .animation(.easeInOut, value: viewModel.words)
        .onAppear(perform: viewModel.onAppear)
        .onDisappear(perform: viewModel.onDisappear)
        .navigationBarTitle(Text("Words"), displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    appViewData.addWordNavigationSelection = getAddWordNavigationTag()
                }) {
                    Image.asset.plus
                }
            }
        }
    }
    
    private func getAddWordNavigationTag() -> String { "findWord\(viewModel.categoryId)" }
    private func getTrainingNavigationTag() -> String { "learning\(viewModel.categoryId)" }
    private func getRevisingNavigationTag() -> String { "revising\(viewModel.categoryId)" }
    
    private func deleteWords(at offsets: IndexSet) {
        viewModel.deleteWords(indexes: offsets)
    }
    
    private func getFindWordView(categoryId: Int) -> FindWordView {
        if let view = Self.findWordViewsMap[categoryId] {
            return view
        }

        let findWordView = FindWordAssembly().build(categoryId: categoryId)
        Self.findWordViewsMap[categoryId] = findWordView
        return findWordView
    }
}

struct WordList_Previews: PreviewProvider {
    static var previews: some View {
        let words = [
            WordRowInfo(
                id: 0,
                word: "food",
                definition: "definition of food",
                wordStatus: .learned
            ),
            WordRowInfo(
                id: 1,
                word: "place",
                definition: "definition of place",
                wordStatus: .new
            )
        ]
        let viewModel = WordListViewModel(
            categoryId: 0,
            wordDao: WordDao(),
            wordListSettingsStorage: WordListSettingsStorage(),
            trainingSettingsStorage: TrainingSettingsStorage()
        )
        viewModel.words = words
        return WordListView(viewModel: viewModel)
    }
}
