//
//  SwiftUIView.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2022/05/02.
//

import SwiftUI
import AlertToast

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    @State var showAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGray.ignoresSafeArea()
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
                                .contextMenu {
                                    ContextMenuView(viewModel: viewModel, showAlert: $showAlert, itemInfo: drawableItem)
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
        .toast(isPresenting: $showAlert, duration: 3, tapToDismiss: true) {
            AlertToast(displayMode: .hud, type: .complete(.green), title: "알림이 설정되었습니다", subTitle: "응모가 시작되면 알려드려요!")
        }
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
                    .foregroundColor(.gray)
            }
            .mask {
                RoundedRectangle(cornerRadius: 15)
            }
            .shadow(radius: 10, y: 5)
            Text(title)
                .foregroundColor(.textBlack)
                .fontWeight(.black)
            Text(theme)
                .foregroundColor(.gray)
                .fontWeight(.regular)
        }
    }
}

struct ContextMenuView: View {
    @ObservedObject var viewModel: MainViewModel
    @Binding var showAlert: Bool
    let itemInfo: DrawableItem
    
    var body: some View {
        VStack {
            Button {
                // 알림 설정
                Task {
                    showAlert = try await viewModel.addEvent(item: itemInfo)
                }
            } label: {
                Label("알림 설정하기", systemImage: "clock.badge.checkmark")
            }
            Button(role: .destructive) {
                // 알림 취소
            } label: {
                Label("알림 취소하기", systemImage: "clock")
            }
        }
    }
}
