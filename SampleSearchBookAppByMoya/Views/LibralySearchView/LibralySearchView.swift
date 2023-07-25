//
//  LibralySearchView.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/08.
//

import SwiftUI



struct LibralySearchView: View {
    
    @ObservedObject var viewModel: LibralySearchViewModel
    weak var presenter: LibralySearchViewPresentation?
    
    @State var prefectureText = ""
    @State var cityText = ""
    @State var searchLimit = 10
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                NavigationStack {
                    VStack {
                        searchAreaView()
                            .padding(.horizontal, 20)
                            .padding(.vertical, 15)
                        contentView()
                        Spacer()
                    }
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .navigationTitle("図書館検索")
                    .navigationBarTitleDisplayMode(.inline)
                }
                
                if viewModel.requestStatus == .requesting {
                    Indicator(indicatorType: .large)
                        .ignoresSafeArea()
                }
            }
        }
        .onAppear {
            presenter?.viewDidApper()
        }
    }
    
    private func searchAreaView() -> some View {
        
        HStack {
            TextField("都道府県を入力してください。", text: $prefectureText)
                .textFieldStyle(.roundedBorder)
                .overlay(viewModel.validationFailedList.contains(.pref) ? Color.red.opacity(0.3) : .clear)
            
            Spacer(minLength: 5)
            
            Button {
                
                presenter?.tappedSearchButton(pref: prefectureText, city: cityText, limit: searchLimit)
            } label: {
                Image(systemName: "magnifyingglass")
                    .frame(width: 50, height: 50)
                    .foregroundColor(viewModel.isValidationSuccessed ? .black : .gray)
            }
        }
    }
    
    @ViewBuilder
    private func contentView() -> some View {

        VStack {
            Button {
                presenter?.tappedToggleOptionButton()
            } label: {
                HStack {
                    Text(viewModel.isOpenOptionViwe ? "" : "オプション")
                    Image(systemName: "triangle.circle")
                        .rotationEffect(viewModel.isOpenOptionViwe ? .degrees(180) : .zero)
                }
                .padding(.bottom, viewModel.isOpenOptionViwe ? 20 : 0)
                .foregroundColor(.black)
                .animation(.default, value: viewModel.isOpenOptionViwe)
            }

            optionSearchView()
                .animation(.default, value: viewModel.isOpenOptionViwe)

            if !viewModel.searchLibralies.isEmpty {

                List {
                    ForEach(viewModel.searchLibralies) { item in
                        NavigationLink {

                            presenter?.tappedLibralyListRow(id: item.id)
                        } label: {

                            libralyListCell(item)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
    
    private func libralyListCell(_ item: LibralyInfoData) -> some View {
        
        HStack {
            Text(item.short)
            Spacer()
        }
        .frame(height: 35)
    }
    
    @ViewBuilder
    private func optionSearchView() -> some View {
        
        if viewModel.isOpenOptionViwe {
            
            VStack {
                HStack {
                    Text("市区町村")
                        .padding(.trailing, 10)
                    TextField("任意", text: $cityText)
                        .textFieldStyle(.roundedBorder)
                }
                HStack {
                    Text("検索制限")
                        .padding(.trailing, 10)
                    TextField("任意", value: $searchLimit, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .frame(minWidth: 100)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 15)
        }
        
        Divider()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LibralySearchViewRouter.assembleModules()
    }
}
