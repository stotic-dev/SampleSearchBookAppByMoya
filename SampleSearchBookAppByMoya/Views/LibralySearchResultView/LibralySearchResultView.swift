//
//  LibralySearchResultView.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/08.
//

import SwiftUI

enum LibralyInfoType: String {
    case address = "住所"
    case tel = "電話番号"
}

struct ListButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? .gray.opacity(0.4) : .clear)
    }
}

struct LibralySearchResultView: View {
    
    @ObservedObject var viewModel: LibralySearchResultViewModel
    @State var titleText = ""
    
    let presenter: LibralySearchResultPresentation
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ScrollView {
                    VStack {
                        Group {
                            createInfoRow(type: .address)
                                .padding(.bottom, 20)
                            
                            createInfoRow(type: .tel)
                        }
                        .font(.system(size: 20))
                        .padding(.horizontal, 20)
                        
                        createDetailButton()
                        
                        Divider()
                        
                        createSearchBookArea()
                            .padding(.horizontal, 20)
                        
                        if !viewModel.searchBooks.isEmpty {
                            List {
                                ForEach(viewModel.searchBooks) { bookObj in
                                    Button {
                                        print("tap book title: \(bookObj.volumeInfo.title)")
                                        presenter.tappedBookView(bookInfo: bookObj)
                                    } label: {
                                        createBookListRow(obj: bookObj)
                                    }
                                    .buttonStyle(ListButtonStyle())
                                    .alert(isPresented: $viewModel.isShowAlertView, content: {
                                        Alert(title: Text(viewModel.alertMessage), dismissButton: .default(Text("OK"), action: {
                                            viewModel.alertMessage = ""
                                        }))
                                    })
                                }
                            }
                            .frame(height: proxy.size.height / 1.5)
                            .listStyle(.plain)
                        }
                    }
                }
                .padding(.top, 20)
                
                if viewModel.isShowIndicator {
                    
                    Indicator(indicatorType: .large)
                        .ignoresSafeArea()
                }
                
                if viewModel.isShowBookStatusView {
                    
                    LibraryBookStatusView(viewModel: viewModel)
                        .ignoresSafeArea()
                }
            }
            .navigationTitle(viewModel.searchLibraly!.short)
        }
    }
    
    @ViewBuilder
    func createInfoRow(type: LibralyInfoType) -> some View {
        
        let title = type.rawValue
        
        switch type {
            
        case .address:
            infoRow(title: title, value: viewModel.searchLibraly!.address)
        case .tel:
            infoRow(title: title, value: viewModel.searchLibraly!.post)
        }
    }
    
    func infoRow(title: String, value: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .fontWeight(.bold)
                
                Text(value)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
        }
    }
    
    func createDetailButton() -> some View {
        
        Button {
            presenter.tappedDetailText()
        } label: {
            Text("詳しくはこちらから")
        }
        .padding()
    }
    
    func createSearchBookArea() -> some View {
        
        GeometryReader { proxy in
            VStack(alignment: .leading) {
                Text("蔵書検索")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.bottom, 10)
                
                HStack {
                    TextField("キーワードを入力", text: $titleText)
                        .textFieldStyle(.roundedBorder)
                    
                    Button {
                        presenter.tappedSearchButton(keyword: titleText, limit: 10)
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .frame(height: 100)
    }
    
    func createBookListRow(obj: BookInfoData) -> some View {
        
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: obj.volumeInfo.imageLinks?.smallThumbnail ?? "")?.convertToHttpsIfNeeded()) { image in
                image
                    .resizable()
            } placeholder: {
                Indicator(indicatorType: .minimun)
            }
            .frame(width: 100 ,height: 180)

            VStack(alignment: .leading) {
                Text(obj.volumeInfo.title)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.bottom, 5)
                
                Text(obj.volumeInfo.authors?.joined(separator: ", ") ?? "No Authors")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
                
                Text(obj.searchInfo?.textSnippet ?? "No Description")
                    .font(.system(size: 14, weight: .light))
                    .padding(.top, 10)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .frame(maxHeight: 300)
        .padding(.vertical, 10)
    }
}

struct LibralySearchResultView_Previews: PreviewProvider {
    static let entity = {
        LibralyInfoData(systemid: "aaaa", systemname: "bbbb", libkey: "aaaaa", libid: "aaaaa", short: "aaaa", formal: "dddddd", url_pc: "sssss", address: "ssssssssssssssssssssssssssssssssssssssssssssssssss", pref: "aaaaa", city: "aaaaa", post: "aaaaa", tel: "aaaaa", geocode: "aaaaa", category: "aaaaa")
    }
    
    static var previews: some View {
        LibralySearchResultRouter.assembleModules(entity: entity())
    }
}
