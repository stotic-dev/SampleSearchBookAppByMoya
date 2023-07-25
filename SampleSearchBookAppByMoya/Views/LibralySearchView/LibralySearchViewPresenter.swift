//
//  LibralySearchViewPresenter.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/08.
//

import Foundation
import Combine

protocol LibralySearchViewPresentation: AnyObject {
    
    /// 表示時の処理
    func viewDidApper()
    
    /// 検索ボタンをタップした時の処理
    func tappedSearchButton(pref: String, city: String, limit: Int)
    
    /// 検索オプション開閉ボタンをタップした時の処理
    func tappedToggleOptionButton()
    
    /// 図書館リストをタップした時の処理
    func tappedLibralyListRow(id: String) -> LibralySearchResultView
}

final class LibralySearchViewPresenter {
    
    struct Dependency {
        let viewModel: LibralySearchViewModel
        let router: LibralySearchViewWireframe
        let searchLibralyInteractor: SearchLibralyUsecase
        let validationInteractor: ValidationInteractorUsecase
    }
    
    var dependency: Dependency!
    
    private let prefObservePublisher = PassthroughSubject<String?, Never>()
    private let cityObservePublisher = PassthroughSubject<String?, Never>()
    private let limitObservePublisher = PassthroughSubject<Int?, Never>()
    
    private var apiCancellabel: Set<AnyCancellable> = []
    
    init() {}
}

extension LibralySearchViewPresenter: LibralySearchViewPresentation {

    func viewDidApper() {
        
        setValidationObserve()
    }

    func tappedSearchButton(pref: String, city: String, limit: Int) {
        
        let model = dependency.viewModel
        model.pref = pref
        model.city = city
        model.limit = limit
        
        requestGetLibraly()
    }
    
    func tappedToggleOptionButton() {
        
        dependency.viewModel.isOpenOptionViwe.toggle()
        setValidationObserve()
    }
    
    func tappedLibralyListRow(id: String) -> LibralySearchResultView {
        
        guard let targetEntity = selectLibralyEntity(id: id) else {
            
            fatalError("failed create Next View")
        }
        
        return dependency.router.showLibralySearchResultView(entity: targetEntity)
    }
}

private extension LibralySearchViewPresenter {
    
    func setValidationObserve() {
        if dependency.viewModel.isOpenOptionViwe {
            
            dependency.validationInteractor.execute(prefObserver: prefObservePublisher.eraseToAnyPublisher(), cityObserver: cityObservePublisher.eraseToAnyPublisher(), limitObserver: limitObservePublisher.eraseToAnyPublisher())
        }
        else {
            
            dependency.validationInteractor.execute(prefObserver: prefObservePublisher.eraseToAnyPublisher(), cityObserver: nil, limitObserver: nil)
        }
    }
    
    func selectLibralyEntity(id: String) -> LibralyInfoData? {
        
        dependency.viewModel.searchLibralies.first(where: { $0.id == id})
    }
    
    func requestGetLibraly() {
        let model = dependency.viewModel
        model.requestStatus = .requesting
        
        let requestParam = LibraryParameter(prefecturer: model.pref, city: model.city, limit: model.limit)
        dependency.searchLibralyInteractor.execute(param: requestParam)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                
                guard let self = self else { return }
                
                if case .failure(let error) = completion {
                    
                    self.dependency.viewModel.requestStatus = .receiveError
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] data in
                
                guard let self = self else { return }
                self.dependency.viewModel.searchLibralies = data
                self.dependency.viewModel.requestStatus = .receiveResponse
            }
            .store(in: &apiCancellabel)
    }
    
    func clearApiObserver() {
        
        apiCancellabel.removeAll()
    }
}
