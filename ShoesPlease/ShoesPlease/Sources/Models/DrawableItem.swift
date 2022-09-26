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
    var monthDay: String?
}

extension DrawableItem {
    static var dummyDrawableItems: [DrawableItem] = (0..<10).map { _ in
        DrawableItem(title: "더미 나이키 신발", theme: "더미 theme", image: "https://static-breeze.nike.co.kr/kr/ko_kr/cmsstatic/product/DO2123-113/8a7aac70-ba05-4588-8b56-c038a00be420_primary.jpg?snkrBrowse", href: "더미 데이터 href", monthDay: "9/24")
    }
    
    static var dummyDrawaingItems: [DrawableItem] = (0..<2).map { _ in
        DrawableItem(title: "응모중인 신발", theme: "더미 theme", image: "https://static-breeze.nike.co.kr/kr/ko_kr/cmsstatic/product/DO2123-113/8a7aac70-ba05-4588-8b56-c038a00be420_primary.jpg?snkrBrowse", href: "더미 데이터 href", monthDay: Date().toString(format: "M/dd"))
    }
}
