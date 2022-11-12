//
//  CardView.swift
//  ShoesPlease
//
//  Created by YoungK on 2022/10/09.
//

import Foundation
import SwiftUI

struct CardView: View {
    let title: String
    let theme: String
    let imageURL: String
    let date: String
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: imageURL), transaction: Transaction(animation: .spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.5))) { phase in
                switch phase {
                //SUCCESS : 이미지 로드 성공
                //FAILURE : 이미지 로드 실패 에러
                //EMPTY : 이미지 없음. 이미지가 로드되지 않음
                case .success(let image):
                    image.resizable().scaledToFill().transition(.scale)
                case .failure(_):
                    ZStack {
                        RoundedRectangle(cornerRadius: 15).frame(minWidth: ScreenSize.width * 2/3, maxWidth: ScreenSize.width * 3/4, minHeight: ScreenSize.width * 2/3, maxHeight: ScreenSize.width * 3/4).foregroundColor(.white)
                        Image(systemName: "xmark.icloud.fill").foregroundColor(.red)
                    }
                case .empty:
                    ZStack {
                        RoundedRectangle(cornerRadius: 15).frame(minWidth: ScreenSize.width * 2/3, maxWidth: ScreenSize.width * 3/4, minHeight: ScreenSize.width * 2/3, maxHeight: ScreenSize.width * 3/4).foregroundColor(.white)
                        ProgressView(Const.String.progressMessage.randomElement()!)
                    }.transition(.scale)
                    
                @unknown default:
                    RoundedRectangle(cornerRadius: 15).frame(minWidth: ScreenSize.width * 2/3, maxWidth: ScreenSize.width * 3/4, minHeight: ScreenSize.width * 2/3, maxHeight: ScreenSize.width * 3/4).foregroundColor(.white)
                    Image(systemName: "exclamationmark.icloud.fill").foregroundColor(.blue)
                }
            }
            .mask {
                RoundedRectangle(cornerRadius: 15)
            }
            .shadow(radius: 10, y: 5)
            .overlay(content: {
                if isDrawing(compareToDate: date) {
                    GradientBorderView()
                }
            })
            .overlay(alignment: .topLeading, content: {
                CircleCalendar
                    .offset(x: 20, y: 20)
            })
            Text(title)
                .foregroundColor(.textBlack)
                .fontWeight(.black)
            Text(theme)
                .foregroundColor(.gray)
                .fontWeight(.regular)
        }
    }
    
    var CircleCalendar: some View {
        ZStack {
            Circle()
                .frame(width: 100, height: 100)
                .foregroundColor(Color.black)
                .opacity(0.1)
            Text(date)
                .font(.title)
                .fontWeight(.black)
                .foregroundColor(Color.black)
        }
    }
    
    private func isDrawing(compareToDate: String) -> Bool {
        return compareToDate == Date().toString(format: "M/dd")
    }
}
