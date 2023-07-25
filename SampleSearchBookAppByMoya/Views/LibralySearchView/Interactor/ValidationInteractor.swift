//
//  LibralySearchResultPresenter.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/08.
//

import Foundation
import Combine

protocol ValidationInteractorUsecase {
    
    func execute(prefObserver: AnyPublisher<String?, Never>, cityObserver: AnyPublisher<String?, Never>?, limitObserver: AnyPublisher<Int?, Never>?)
}

final class ValidationInteractorInteractor {

    private struct Dependency {
        let viewModel: LibralySearchViewModel
    }
    private var dependency: Dependency!
    private var cansellable: Set<AnyCancellable> = []
    
    init(viewModel: LibralySearchViewModel) {
        self.dependency = Dependency(viewModel: viewModel)
    }
}

extension ValidationInteractorInteractor: ValidationInteractorUsecase {
    
    func execute(prefObserver: AnyPublisher<String?, Never>, cityObserver: AnyPublisher<String?, Never>?, limitObserver: AnyPublisher<Int?, Never>?) {
        
        cansellable.removeAll()
        
        // observerのsubscribeを開始
        if let cityObserver = cityObserver,
           let limitObserver = limitObserver {
            
            withOptionObserve(prefObserver: prefObserver, cityObserver: cityObserver, limitObserver: limitObserver)
        }
        else {
            
            onlyPrefObserve(with: prefObserver)
        }
    }
}

private extension ValidationInteractorInteractor {
    
    func onlyPrefObserve(with observer: AnyPublisher<String?, Never>) {
        
        observer
            .receive(on: DispatchQueue.main)
            .sink {[weak self] pref in
            
            guard let self = self else { return }
            
            if pref == nil {
                self.dependency.viewModel.validationFailedList = [.pref]
            }
        }
        .store(in: &cansellable)
    }
    
    func withOptionObserve(prefObserver: AnyPublisher<String?, Never>, cityObserver: AnyPublisher<String?, Never>, limitObserver: AnyPublisher<Int?, Never>) {
        
        prefObserver.combineLatest(cityObserver, limitObserver)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pref, city, limit in
                
                guard let self = self else { return }
                
                self.dependency.viewModel.validationFailedList.removeAll()
                
                if pref == nil {
                    self.dependency.viewModel.validationFailedList.append(.pref)
                }
                
                if city == nil {
                    self.dependency.viewModel.validationFailedList.append(.city)
                }
                
                if limit == nil {
                    self.dependency.viewModel.validationFailedList.append(.limit)
                }
            }
            .store(in: &cansellable)
    }
}


