//
//  ContentView.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2022/04/18.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = MainViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.cream.ignoresSafeArea(edges: .bottom)
                if viewModel.drawableItems.isEmpty {
                    Text("진행중인 응모가 없어요 !")
                        .foregroundColor(.gray)
                }
                RefreshableScrollView(isRefreshing: $viewModel.isRefreshing) {
                    Text(viewModel.testString)
                        .font(.headline)
                    ZStack {
                        Color.clear// 비어있을 때도 당길 수 있도록 투명 뷰
                        VStack(spacing: 20) {
                            ForEach(viewModel.drawableItems) { drawableItem in
                                NavigationLink(destination: MyWebView(urlToLoad: Const.URL.baseURL+drawableItem.href)) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(.white)
                                        VStack {
                                            Text(drawableItem.title)
                                                .foregroundColor(.black)
                                            Text(drawableItem.theme)
                                                .foregroundColor(.gray)
                                            AsyncImage(url: URL(string: drawableItem.image)) { image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                            } placeholder: {
                                                Color.gray
                                            }
                                            .mask {
                                                RoundedRectangle(cornerRadius: 15)
                                            }
                                        }
                                    }// ZStack
                                }// NavigationLink
                            }
                        }// VStack
                    }// ZStack
                } onRefresh: {
                    print(#fileID, #function, #line, "onRefresh")
                    viewModel.refreshActionSubject.send()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        viewModel.refreshActionSubject.send()
//                    }// 딜레이 테스트용
                }// RefreshableScrollView
                .padding(.horizontal, 10)
                .navigationTitle("응모 목록")
                //.navigationBarTitleDisplayMode(.inline)// 다시 사용할 수도 있어서 주석처리
            }// ZStack
        }// NavigationView
        .navigationViewStyle(.stack)// 안붙이면 콘솔창에 오류가 주르륵
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
