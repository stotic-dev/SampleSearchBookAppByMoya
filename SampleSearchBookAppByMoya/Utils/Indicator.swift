//
//  Indicator.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/14.
//

import Foundation
import SwiftUI

enum IndicatorType: CGFloat {
    case minimun = 20
    case normal = 35
    case large = 50
}

struct Indicator: View {
    
    let indicatorType: IndicatorType
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.3)
            
            VStack(alignment: .center) {
                Spacer()
                
                ActiveIndicator()
                    .frame(width: indicatorType.rawValue, height: indicatorType.rawValue)
                
                Spacer()
            }
        }
    }
}

fileprivate struct ActiveIndicator: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<ActiveIndicator>) -> some UIActivityIndicatorView {
        UIActivityIndicatorView(style: .large)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.startAnimating()
    }
    
}
