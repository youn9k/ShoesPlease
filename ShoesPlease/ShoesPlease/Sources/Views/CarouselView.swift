//
//  CarouselView.swift
//  ShoesPlease
//
//  Created by YoungK on 2022/09/24.
//

import SwiftUI

struct CarouselView: View {
    let items: [DrawableItem]
    var body: some View {
        //NavigationView {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 20) {
                        ForEach(items) { item in
                            GeometryReader { proxy in
                                let scale = getScale(proxy: proxy)
                                VStack(spacing: 30) {
                                    AsyncImage(url: URL(string: item.image), transaction: Transaction(animation: .spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.5))) { phase in
                                        switch phase {
                                        //SUCCESS : 이미지 로드 성공
                                        //FAILURE : 이미지 로드 실패 에러
                                        //EMPTY : 이미지 없음. 이미지가 로드되지 않음
                                        case .success(let image):
                                            NavigationLink(destination: MyWebView(urlToLoad: Const.URL.baseURL+item.href)) {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .foregroundColor(Color(.sRGB, red: 0.965, green: 0.965, blue: 0.965, opacity: 1))
                                                        .frame(height: 300)
                                                        .shadow(radius: 5)
                                                    image.resizable().scaledToFit().frame(width: 180).clipped()
                                                }.transition(.scale).scaleEffect(.init(width: scale, height: scale)).padding(.vertical)
                                            }
                                            
                                        case .failure(_):
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15).frame(width: ScreenSize.width / 1.2, height: ScreenSize.width/1.2) .foregroundColor(.white)
                                                Image(systemName: "xmark.icloud.fill").foregroundColor(.red)
                                            }
                                        case .empty:
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15).frame(width: ScreenSize.width / 1.2, height: ScreenSize.width/1.2) .foregroundColor(.white)
                                                ProgressView("신발 가져오는 중")
                                            }.transition(.scale)
                                            
                                        @unknown default:
                                            RoundedRectangle(cornerRadius: 15).frame(width: ScreenSize.width / 1.2, height: ScreenSize.width/1.2) .foregroundColor(.white)
                                            Image(systemName: "exclamationmark.icloud.fill").foregroundColor(.blue)
                                        }
                                    }
                                    VStack {
                                        Text(item.title)
                                            .foregroundColor(.textBlack)
                                            .fontWeight(.black)
                                        Text(item.theme)
                                            .foregroundColor(.gray)
                                            .fontWeight(.regular)
                                        Text(item.monthDay ?? "")
                                            .foregroundColor(.gray)
                                            .fontWeight(.regular)
                                        
                                    }
                                    
                                }// VStack
                            }// GeometryReader
                            .frame(width: 125, height: 400)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 32)
                        }// ForEach
                        Spacer()
                            .frame(width: 16)
                    }// HStack
                }// ScrollView
            }// VStack
        //}// NavigationView
        
    }
    
    func getScale(proxy: GeometryProxy) -> CGFloat {
        let midPoint: CGFloat = 125
        let viewFrame = proxy.frame(in: CoordinateSpace.global)
        var scale: CGFloat = 1.0
        let deltaXAnimationThreshold: CGFloat = 150 // 커지는 정도 조절 (기본값: 125)
        let diffFromCenter = abs(midPoint - viewFrame.origin.x - deltaXAnimationThreshold / 2)
        if diffFromCenter < deltaXAnimationThreshold {
            scale = 1 + (deltaXAnimationThreshold - diffFromCenter) / 500
        }
        return scale
    }
    
}

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}