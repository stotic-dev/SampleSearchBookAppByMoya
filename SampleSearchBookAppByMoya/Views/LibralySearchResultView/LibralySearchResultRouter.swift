//
//  LibralySearchResultRouter.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/08.
//

import Foundation
import UIKit

protocol LibralySearchResultWireframe {
    
    static func assembleModules(entity: LibralyInfoData) -> LibralySearchResultView
    
    /// 図書館ページを開く
    func openDetailUrl(url: String)
}

class LibralySearchResultRouter {
    
    struct Depedency {
        let viewModel: LibralySearchResultViewModel
    }
    
    var dependency: Depedency!
    
    init(viewModel: LibralySearchResultViewModel) {
        self.dependency = Depedency(viewModel: viewModel)
    }
}

extension LibralySearchResultRouter: LibralySearchResultWireframe {
    
    static func assembleModules(entity: LibralyInfoData) -> LibralySearchResultView {
        
        let viewModel = LibralySearchResultViewModel()
        viewModel.searchLibraly = entity
        
        let router = LibralySearchResultRouter(viewModel: viewModel)
        let presenter = LibralySearchResultPresenter()
        let view = LibralySearchResultView(viewModel: viewModel, presenter: presenter)
        let searchBookInteractor = SearchBookInteractor()
        let searchLibraryBookInteractor = SearchLibralyHasBooksInteractor()
        presenter.dependencies = .init(viewModel: viewModel, router: router, searchBookInteractor: searchBookInteractor, searchLibraryHasBookInteractor: searchLibraryBookInteractor)
        
        return view
    }
    
    func openDetailUrl(url: String) {
        guard let url = URL(string: url) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
        else {
            print("can not open detail web page URL: \(url.absoluteString)")
        }
    }
}
