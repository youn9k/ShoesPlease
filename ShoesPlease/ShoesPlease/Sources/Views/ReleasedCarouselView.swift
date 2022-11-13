//
//  ReleasedCarouselView.swift
//  ShoesPlease
//
//  Created by YoungK on 2022/09/24.
//

import SwiftUI

struct ReleasedCarouselView: View {
    @ObservedObject var viewModel: MainViewModel
    @Binding var showAlert: Bool
    @Binding var isSuccess: Bool
    let items: [ReleasedItem]
    var body: some View {
        //VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 25) {
                    ForEach(items) { item in
                        let message: String = Const.String.progressMessage.randomElement()!
                        GeometryReader { proxy in
                            let scale = getScale(proxy: proxy, zoom: 1.2)
                            VStack(spacing: 30) {
                                AsyncImage(url: URL(string: item.image), transaction: Transaction(animation: .spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.5))) { phase in
                                    switch phase {
                                        //SUCCESS : 이미지 로드 성공
                                        //FAILURE : 이미지 로드 실패 에러
                                        //EMPTY : 이미지 없음. 이미지가 로드되지 않음
                                    case .success(let image):
                                        NavigationLink(destination: MyWebView(urlToLoad: Const.URL.baseURL+item.href)) {
                                            ZStack {
                                                BackgroundRectangleView
                                                    .shadow(radius: 5)
                                                    .frame(width: 180, height: 180)
                                                image
                                                    .resizable()
                                                    .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                                                    .scaledToFit()
                                                    .frame(width: 180)
                                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                            }
                                            .transition(.scale)
                                            .scaleEffect(.init(width: scale, height: scale))
                                            .padding(.vertical)
                                        }

                                    case .failure(_):
                                        ZStack {
                                            BackgroundRectangleView.shadow(radius: 5).frame(width: 180, height: 180)
                                            Image(systemName: "xmark.icloud.fill").foregroundColor(.red)
                                        }
                                    case .empty:
                                        ZStack {
                                            BackgroundRectangleView.shadow(radius: 5).frame(width: 180, height: 180)
                                            ProgressView(message)
                                        }.transition(.scale)

                                    @unknown default:
                                        BackgroundRectangleView.shadow(radius: 5).frame(width: 180, height: 180)
                                        Image(systemName: "exclamationmark.icloud.fill").foregroundColor(.blue)
                                    }
                                }
                                VStack(alignment: .leading) {
                                    Text(item.title)
                                        .font(.system(size: 15, weight: .bold, design: .rounded))
                                        .foregroundColor(Color.textBlack)
                                    Text(item.theme)
                                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                                        .lineLimit(1)
                                        .foregroundColor(Color.textBlack)
                                    Text(item.date)
                                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                                        .foregroundColor(.gray)
                                        .fontWeight(.semibold)
                                }
                            }// VStack
                        }// GeometryReader
                        .frame(width: 125, height:300)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 32)
                        // 여기까지가 하나의 셀
                    }// ForEach
                    //오른쪽 끝으로 갔을때 여백을 위해
                    Spacer()
                        .frame(width: 16)
                }// HStack
            }// ScrollView
        //}// VStack
    }// body
    
    var BackgroundRectangleView: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundColor(Color(.sRGB, red: 0.965, green: 0.965, blue: 0.965, opacity: 1))
    }
    
    private func getScale(proxy: GeometryProxy, zoom: Float = 1) -> CGFloat {
        let midPoint: CGFloat = 125
        let viewFrame = proxy.frame(in: CoordinateSpace.global)
        var scale: CGFloat = 1.0
        let deltaXAnimationThreshold: CGFloat = CGFloat(125 * zoom)
        let diffFromCenter: CGFloat = abs(midPoint - viewFrame.origin.x - deltaXAnimationThreshold / 2)
        if diffFromCenter < deltaXAnimationThreshold {
            scale = 1 + (deltaXAnimationThreshold - diffFromCenter) / 500
        }
        return scale
    }
    
    private func isDrawing(_ item: ReleasedItem) -> Bool {
        return item.date == Date().toString(format: "M/dd")
    }
}

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct GradientBorderView: View {
    private var colors: [Color] = [.red, .yellow, .green, .blue, .purple, .red]
    @State private var gradientAngle: Double = 0
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .strokeBorder(
                AngularGradient(gradient: Gradient(colors: colors), center: .center, angle: .degrees(gradientAngle)))
            .onAppear {
                withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                    gradientAngle = 360
                }
            }
    }
}
