//
//  LibralySearchViewRouter.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/08.
//

import Foundation
import SwiftUI

protocol LibralySearchViewWireframe {

    /// Viewの生成
    static func assembleModules() -> LibralySearchView
    
    /// LibralySearchResultViewへ遷移
    func showLibralySearchResultView(entity: LibralyInfoData) -> LibralySearchResultView
}

final class LibralySearchViewRouter {
    
    private struct Dependency {
        let viewModel: LibralySearchViewModel
        let presenter: LibralySearchViewPresentation
    }
    private var dependency: Dependency!
    
    init(viewModel: LibralySearchViewModel, presenter: LibralySearchViewPresentation) {
        self.dependency = Dependency(viewModel: viewModel, presenter: presenter)
    }
}

extension LibralySearchViewRouter: LibralySearchViewWireframe {
    
    static func assembleModules() -> LibralySearchView {
        
        let viewModel = LibralySearchViewModel()
        let presenter = LibralySearchViewPresenter()
        let router = LibralySearchViewRouter(viewModel: viewModel, presenter: presenter)
        let searchInteractor = SearchLibralyInteractor()
        let validationInteractor = ValidationInteractorInteractor(viewModel: viewModel)
        let view = LibralySearchView(viewModel: viewModel, presenter: presenter)
    
        presenter.dependency = .init(viewModel: viewModel, router: router, searchLibralyInteractor: searchInteractor, validationInteractor: validationInteractor)
        
        return view
    }
    
    func showLibralySearchResultView(entity: LibralyInfoData) -> LibralySearchResultView {
        LibralySearchResultRouter.assembleModules(entity: entity)
    }
}
