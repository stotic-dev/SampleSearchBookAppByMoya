//
//  LibraryBookStatusView.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/22.
//

import SwiftUI

struct LibraryBookStatusView: View {
    
    @ObservedObject var viewModel: LibralySearchResultViewModel
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color(.black)
                    .opacity(0.4)
                    .ignoresSafeArea()
                
                ZStack {
                    Color.white
                    
                    VStack {
                        HStack {
                            Text(viewModel.libraryBookEntity?.title ?? "No Title")
                                .font(.title)
                            Spacer()
                            Button {
                                viewModel.isShowBookStatusView.toggle()
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(.gray)
                                    .frame(width: 40, height: 40)
                            }
                        }
                        
                        Divider()
                        
                        ZStack {
                            Color.teal
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("貸出状況")
                                        .font(.title3)
                                    
                                    ForEach(viewModel.libraryBookEntity?.libraryStatus ?? []) { statusInfo in
                                        HStack {
                                            Text(statusInfo.place)
                                                .padding(.trailing, 10)
                                            Text(statusInfo.status.rawValue)
                                            Spacer()
                                        }
                                    }
                                }
                                
                                Spacer()
                            }
                            .padding()
                        }
                        .cornerRadius(8)
                        .contentShape(RoundedRectangle(cornerRadius: 8))
                        
                        
                        ZStack {
                            Color.gray
                            
                            HStack(alignment: .top) {
                                VStack(alignment: .leading) {
                                    Text("概要")
                                        .font(.title2)
                                        .padding(.bottom, 8)
                                    Text(viewModel.libraryBookEntity?.description ?? "No Description")
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                
                                Spacer()
                            }
                            .padding()
                        }
                        .frame(maxHeight: calcViewHeight(size: proxy) / 2)
                        .cornerRadius(8)
                        .contentShape(RoundedRectangle(cornerRadius: 8))
                        
                        Spacer()
                            .layoutPriority(1000)
                    }
                    .padding()
                }
                .cornerRadius(20)
                .contentShape(RoundedRectangle(cornerRadius: 20))
                .frame(width: calcViewWidth(size: proxy))
                .frame(maxHeight: calcViewHeight(size: proxy))
                .shadow(radius: 20)
            }
            .onTapGesture {
                viewModel.isShowBookStatusView.toggle()
            }
        }
    }
    
    private func calcViewWidth(size: GeometryProxy) -> CGFloat {
        
        return 300
    }
    
    private func calcViewHeight(size: GeometryProxy) -> CGFloat {
        
        return 400
    }
}

struct LibraryBookStatusView_Previews: PreviewProvider {
    @State static var isShowFlg: Bool = true
    static var previews: some View {
        LibraryBookStatusView(viewModel: LibralySearchResultViewModel())
    }
}
