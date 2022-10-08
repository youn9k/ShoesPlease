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
                            VStack(spacing: 30) {
                                switch viewTypeSelection {
                                case .carousel:
                                    CarouselView(viewModel: viewModel, showAlert: $showAlert, isSuccess: $isSuccess, items: viewModel.drawingItems + viewModel.drawableItems)
                                case .list:
                                    ForEach(viewModel.drawingItems) { drawingItem in
                                        NavigationLink(destination: MyWebView(urlToLoad: Const.URL.baseURL+drawingItem.href)) {
                                            CardView(item: drawingItem)
                                        }
                                        .contextMenu {
                                            ContextMenuView(viewModel: viewModel, showAlert: $showAlert, isSuccess: $isSuccess, itemInfo: drawingItem)
                                        }
                                    }
                                    ForEach(viewModel.drawableItems) { drawableItem in
                                        NavigationLink(destination: MyWebView(urlToLoad: Const.URL.baseURL+drawableItem.href)) {
                                            CardView(item: drawableItem)
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

struct CardView: View {
    let item: DrawableItem
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: item.image), transaction: Transaction(animation: .spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.5))) { phase in
                switch phase {
                //SUCCESS : 이미지 로드 성공
                //FAILURE : 이미지 로드 실패 에러
                //EMPTY : 이미지 없음. 이미지가 로드되지 않음
                case .success(let image):
                    image.resizable().scaledToFill().transition(.scale)
                case .failure(_):
                    ZStack {
                        RoundedRectangle(cornerRadius: 15).frame(width: ScreenSize.width / 1.2, height: ScreenSize.width/1.2) .foregroundColor(.white)
                        Image(systemName: "xmark.icloud.fill").foregroundColor(.red)
                    }
                case .empty:
                    ZStack {
                        RoundedRectangle(cornerRadius: 15).frame(width: ScreenSize.width / 1.2, height: ScreenSize.width/1.2) .foregroundColor(.white)
                        ProgressView(Const.String.progressMessage.randomElement()!)
                    }.transition(.scale)
                    
                @unknown default:
                    RoundedRectangle(cornerRadius: 15).frame(width: ScreenSize.width / 1.2, height: ScreenSize.width/1.2) .foregroundColor(.white)
                    Image(systemName: "exclamationmark.icloud.fill").foregroundColor(.blue)
                }
            }
            .mask {
                RoundedRectangle(cornerRadius: 15)
            }
            .shadow(radius: 10, y: 5)
            .overlay(alignment: .topLeading) {
                CircleCalendar
                    .offset(x: 20, y: 20)
            }
            Text(item.title)
                .foregroundColor(.textBlack)
                .fontWeight(.black)
            Text(item.theme)
                .foregroundColor(.gray)
                .fontWeight(.regular)
        }
    }
    
    var CircleCalendar: some View {
        ZStack {
            if item.monthDay != nil {
                Circle()
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color.black)
                    .opacity(0.1)
                Text(item.monthDay ?? "")
                    .font(.title)
                    .fontWeight(.black)
                    .foregroundColor(Color.black)
            }
        }
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
            Button(role: .destructive) {
                // 알림 취소
            } label: {
                Label("알림 취소하기", systemImage: "clock")
            }
        }
    }
}
