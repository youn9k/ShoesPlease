//
//  SwiftUIView.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2022/05/02.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.drawableItems.isEmpty {
                    Text("진행중인 응모가 없어요 !")
                        .foregroundColor(.gray)
                }
                RefreshableScrollView(isRefreshing: $viewModel.isRefreshing) {
                    ZStack {
                        Color.clear// 비어있을 때도 당길 수 있도록 투명 뷰
                        VStack(spacing: 30) {
                            ForEach(viewModel.drawableItems) { drawableItem in
                                NavigationLink(destination: MyWebView(urlToLoad: Const.URL.baseURL+drawableItem.href)) {
                                    CardView(imageURL: drawableItem.image, title: drawableItem.title, theme: drawableItem.theme)
                                }
                            }
                        }
                        .padding(.top, 30)
                    }// ZStack
                } onRefresh: {
                    print(#fileID, #function, #line, "onRefresh")
                    viewModel.refreshActionSubject.send()
                }// RefreshableScrollView
                .padding(.horizontal, 10)
                .navigationTitle("응모 목록")
            }// ZStack
        }// NavigationView
        .navigationViewStyle(.stack)// 안붙이면 콘솔창에 오류가 주르륵
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct CardView: View {
    let imageURL : String
    let title : String
    let theme : String
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: imageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: screen().width / 1.2)
            } placeholder: {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: screen().width / 1.2, height: UIScreen.main.bounds.height / 3)
            }
            .mask {
                RoundedRectangle(cornerRadius: 15)
            }
            .shadow(radius: 10, y: 5)
            Text(title)
                .foregroundColor(.black)
                .fontWeight(.black)
            Text(theme)
                .foregroundColor(.gray)
                .fontWeight(.regular)
        }
    }
}
