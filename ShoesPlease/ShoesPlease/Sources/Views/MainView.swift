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
    @State var isSuccess = false
    @State var viewTypeSelection: MainViewType = .carousel
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGray.ignoresSafeArea()
                if viewModel.drawingItems.isEmpty && viewModel.drawableItems.isEmpty {
                    Text("진행중인 응모가 없어요 !")
                        .foregroundColor(.gray)
                }
                RefreshableScrollView(isRefreshing: $viewModel.isRefreshing) {
                    VStack {
                        Picker("", selection: $viewTypeSelection) {
                            ForEach(MainViewType.allCases, id: \.self) {
                                type in
                                Image(systemName: type.rawValue)
                                    .foregroundColor(.gray)
                            }
                        }.pickerStyle(.segmented).padding()
                        
                        ZStack {
                            Color.clear// 비어있을 때도 당길 수 있도록 투명 뷰
                            VStack(spacing: 90) {
                                switch viewTypeSelection {
                                case .carousel:
                                    CarouselView(viewModel: viewModel, showAlert: $showAlert, isSuccess: $isSuccess, items: viewModel.drawingItems + viewModel.drawableItems)
                                case .list:
                                    ForEach(viewModel.drawingItems) { drawingItem in
                                        NavigationLink(destination: MyWebView(urlToLoad: Const.URL.baseURL+drawingItem.href)) {
                                            CardView(item: drawingItem).frame(minWidth: ScreenSize.width * 2/3, maxWidth: ScreenSize.width * 3/4, minHeight: ScreenSize.width * 2/3, maxHeight: ScreenSize.width * 3/4)
                                        }
                                        .contextMenu {
                                            ContextMenuView(viewModel: viewModel, showAlert: $showAlert, isSuccess: $isSuccess, itemInfo: drawingItem)
                                        }
                                    }
                                    ForEach(viewModel.drawableItems) { drawableItem in
                                        NavigationLink(destination: MyWebView(urlToLoad: Const.URL.baseURL+drawableItem.href)) {
                                            CardView(item: drawableItem).frame(minWidth: ScreenSize.width * 2/3, maxWidth: ScreenSize.width * 3/4, minHeight: ScreenSize.width * 2/3, maxHeight: ScreenSize.width * 3/4)
                                        }
                                        .contextMenu {
                                            ContextMenuView(viewModel: viewModel, showAlert: $showAlert, isSuccess: $isSuccess, itemInfo: drawableItem)
                                        }
                                    }
                                }
                            }
                            .padding(.top, 30)
                            .padding(.horizontal, 15)
                        }// ZStack
                    }
                    
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
            isSuccess ?
            AlertToast(displayMode: .hud, type: .complete(.green), title: "캘린더에 등록 했습니다", subTitle: "응모가 시작되면 알려드려요!") :
            AlertToast(displayMode: .hud, type: .complete(.red), title: "캘린더 등록에 실패했습니다", subTitle: "알 수 없는 오류가 발생했어요")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct ContextMenuView: View {
    @ObservedObject var viewModel: MainViewModel
    @Binding var showAlert: Bool
    @Binding var isSuccess: Bool
    let itemInfo: DrawableItem
    
    var body: some View {
        VStack {
            Button {
                // 알림 설정
                Task {
                    isSuccess = try await viewModel.addEvent(item: itemInfo)
                    showAlert = true
                }
            } label: {
                Label("알림 설정하기", systemImage: "clock.badge.checkmark")
            }
//            Button(role: .destructive) {
//                // 알림 취소
//            } label: {
//                Label("알림 취소하기", systemImage: "clock")
//            }
        }
    }
}
