//
//  drawableItems.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2022/04/20.
//

import Foundation

struct DrawableItem: Identifiable {
    var id = UUID()
    let title: String
    let theme: String
    let image: String
    let href: String
}

extension DrawableItem {
    static var dummyDrawableItems: [DrawableItem] = (1..<10).map { _ in
        DrawableItem(title: "더미 데이터 타이틀", theme: "더미 데이터 theme", image: "https://static-breeze.nike.co.kr/kr/ko_kr/cmsstatic/product/DO2123-113/8a7aac70-ba05-4588-8b56-c038a00be420_primary.jpg?snkrBrowse", href: "더미 데이터 href")
    }
}
