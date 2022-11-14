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
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGray.ignoresSafeArea()
                if viewModel.releasedItems.isEmpty && viewModel.toBeReleasedItems.isEmpty {
                    Text("상품을 준비중이에요 !")
                        .foregroundColor(.gray)
                }
                RefreshableScrollView(isRefreshing: $viewModel.isRefreshing) {
                    VStack(spacing: 30) {
                        HStack {
                            Spacer()
                            Image("navigationCenter")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding(.top, 30)
                            Spacer()
                        }
                        
                        if !viewModel.releasedItems.isEmpty {
                            HStack {
                                Text("출시된 상품을 알려드려요")
                                    .font(.system(size: 20, weight: .black, design: .rounded))
                                    .kerning(-0.6)
                                Spacer()
                            }
                            
                            ReleasedCarouselView(viewModel: viewModel, showAlert: $showAlert, isSuccess: $isSuccess, items: viewModel.releasedItems)
                        }
                        
                        if !viewModel.toBeReleasedItems.isEmpty {
                            HStack {
                                Text("출시 예정인 상품을 알려드려요")
                                    .font(.system(size: 20, weight: .black, design: .rounded))
                                    .kerning(-0.6)
                                Spacer()
                            }
                            
                            ForEach(viewModel.toBeReleasedItems) { item in
                                LuckyDrawItemView(title: item.title, theme: item.theme, date: item.date, releaseDate: item.releaseDate, image: item.image, href: item.href)
                                    .contextMenu {
                                        ContextMenuView(viewModel: viewModel, showAlert: $showAlert, isSuccess: $isSuccess, title: item.title, theme: item.theme, date: item.releaseDate)
                                    }
                            }
                        }
                        
                        Spacer().frame(height: 40)
                    }// VStack
                    .padding(.horizontal, 15)
                } onRefresh: {
                    print(#fileID, #function, #line, "onRefresh")
                    viewModel.refreshActionSubject.send()
                    
            }// RefreshableScrollView
            //.padding(.horizontal, 10)
//            .toolbar {
//                ToolbarItem(placement: .principal){
//                    Image("navigationCenter")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 60, height: 60)
//                }
//            } // toolbar
            }// ZStack
        }// NavigationView
        .navigationViewStyle(.stack)
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
    let title: String
    let theme: String
    let date: String
    
    var body: some View {
        VStack {
            Button {
                // 알림 설정
                Task {
                    let eventName = title + " " + theme + " " + "발매"
                    let eventDate = date.toDate(format: "yyyy-MM-dd HH:mm") ?? Date()

                    isSuccess = try await viewModel.addEvent(name: eventName, date: eventDate)
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

struct LuckyDrawItemView: View {
    let title: String
    let theme: String
    let date: String
    let releaseDate: String
    let image: String
    let href: String
    
    var body: some View {
        NavigationLink(destination: MyWebView(urlToLoad: Const.URL.baseURL+href)) {
            HStack(spacing: 20) {
                AsyncImage(url: URL(string: image), transaction: Transaction(animation: .spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.5))) { phase in
                    switch phase {
                        //SUCCESS : 이미지 로드 성공
                        //FAILURE : 이미지 로드 실패 에러
                        //EMPTY : 이미지 없음. 이미지가 로드되지 않음
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                            .frame(width: 100)
                            .clipShape(Circle())
                            .transition(.scale)
                            .padding(.vertical)
                        
                    case .failure(_):
                        ZStack {
                            BackgroundCircleView().frame(width: 100, height: 100)
                            Image(systemName: "xmark.icloud.fill").foregroundColor(.red)
                        }
                    case .empty:
                        BackgroundCircleView().frame(width: 100, height: 100)
                    @unknown default:
                        ZStack {
                            BackgroundCircleView().frame(width: 100, height: 100)
                            Image(systemName: "exclamationmark.icloud.fill").foregroundColor(.blue)
                        }
                    }
                }
                
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .kerning(-0.6)
                        .foregroundColor(Color.black)
                    Text(theme)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .kerning(-0.6)
                        .lineLimit(1)
                        .foregroundColor(Color.black)
                    Text(releaseDate)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .kerning(-0.6)
                        .foregroundColor(.gray)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
            } // HStack
            .padding(.leading, 10)
            .background {
                RoundedRectangle(cornerRadius: 8).foregroundColor(.white).shadow(radius: 5, x: 3, y: 3)
            }
            
        }

       
    }
    
    func BackgroundCircleView() -> some View {
        Circle()
            .foregroundColor(Color(.sRGB, red: 0.965, green: 0.965, blue: 0.965, opacity: 1))
    }
}
