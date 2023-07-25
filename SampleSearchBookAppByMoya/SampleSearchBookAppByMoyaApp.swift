//
//  SampleSearchBookAppByMoyaApp.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/08.
//

import SwiftUI

@main
struct SampleSearchBookAppByMoyaApp: App {
    var body: some Scene {
        WindowGroup {
            LibralySearchViewRouter.assembleModules()
        }
    }
}
