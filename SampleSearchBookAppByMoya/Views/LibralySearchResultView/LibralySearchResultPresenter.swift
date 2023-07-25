//
//  LibralySearchResultPresenter.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/08.
//

import Foundation
import Combine

protocol LibralySearchResultPresentation: AnyObject {

    /// 図書館の蔵書検索ボタンをタップされた時の処理
    func tappedSearchButton(keyword: String, limit: Int)
    
    /// 詳細情報のボタンをタップされた時の処理
    func tappedDetailText()
    
    /// 書籍をタップされた時の処理
    func tappedBookView(bookInfo: BookInfoData)
}

final class LibralySearchResultPresenter {
    
    struct Depedency {
        let viewModel: LibralySearchResultViewModel
        let router: LibralySearchResultWireframe
        let searchBookInteractor: SearchBookInteractor
        let searchLibraryHasBookInteractor: SearchLibralyHasBooksInteractor
    }
    
    var dependencies: Depedency!
    var apiCancellable: Set<AnyCancellable> = []
    
    init() {
        print("init LibralySearchResultPresenter")
    }
    
    deinit {
        print("deinit LibralySearchResultPresenter")
    }
}

extension LibralySearchResultPresenter: LibralySearchResultPresentation {

    func tappedSearchButton(keyword: String, limit: Int) {
        
        clearObserver()
        
        showIndicator(isShow: true)
        
        let searchBookParam = BookParameter(keyword: keyword, limit: limit)
        requestSearchBookApi(param: searchBookParam)
    }
    
    func tappedDetailText() {
        
        dependencies.router.openDetailUrl(url: dependencies.viewModel.searchLibraly!.url_pc)
    }
    
    func tappedBookView(bookInfo: BookInfoData) {
        
        clearObserver()
        
        showIndicator(isShow: true)
        
        requestSearchLibralyBookApi(bookInfo: bookInfo)
    }
}

private extension LibralySearchResultPresenter {
    
    func requestSearchBookApi(param: BookParameter) {
        
        dependencies.searchBookInteractor.execute(param: param)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                
                guard let self = self else { return }
                
                if case .failure(let error)  = completion {
                    self.showIndicator(isShow: false)
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] data in
                
                guard let self = self else { return }
                
                // dummyコード
                self.dependencies.viewModel.searchBooks = data
                showIndicator(isShow: false)
            }
            .store(in: &apiCancellable)
    }
    
    func requestSearchLibralyBookApi(bookInfo: BookInfoData) {

        guard let observer = dependencies.searchLibraryHasBookInteractor.execute(data: bookInfo, systemId: dependencies.viewModel.searchLibraly!.systemid) else { return }
        
        observer.receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                
                guard let self = self else { return }
                
                if case .failure(let error) = completion {
                    print("occured api Error: \(error)")
                    self.showIndicator(isShow: false)
                }
            } receiveValue: { [weak self] value in
                
                guard let self = self else { return }
                
                self.showIndicator(isShow: false)
                
                if let entity = value {
                    
                    if entity.libraryStatus.isEmpty {
                        self.dependencies.viewModel.alertMessage = "蔵書がありません。"
                        self.dependencies.viewModel.isShowAlertView = true
                        return
                    }
                    
                    self.dependencies.viewModel.libraryBookEntity = entity
                    self.dependencies.viewModel.isShowBookStatusView = true
                }
            }
            .store(in: &apiCancellable)
    }
    
    func clearObserver() {
        apiCancellable.removeAll()
    }
    
    func showIndicator(isShow: Bool) {
        dependencies.viewModel.isShowIndicator = isShow
    }
}
