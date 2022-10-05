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
    
    static var dummyDrawableItems: [DrawableItem] = [
        DrawableItem(title: "에어 조던 1 레트로 하이 OG", theme: "Taxi", image: "https://s3.amazonaws.com/images.kicksfinder.com/products/large/6a617d0e09c64052861f4c636ebfa481_1658956605.jpeg", href: "", monthDay: Calendar.current.date(byAdding: .day, value: 1, to: Date())!.toString(format: "M/dd")),
        DrawableItem(title: "에어 조던 1 미드", theme: "Multi-Color", image: "https://s3.amazonaws.com/images.kicksfinder.com/products/large/16432b8a79bf1464ba9053905f49f156_1650292822.jpeg", href: "", monthDay: Calendar.current.date(byAdding: .day, value: 2, to: Date())!.toString(format: "M/dd")),
        DrawableItem(title: "에어 조던 1 하이", theme: "White/Daybreak", image: "https://s3.amazonaws.com/images.kicksfinder.com/products/large/bf6aa63b01a982465f7efa0f1c5f466a_1612887362.jpeg", href: "", monthDay: Calendar.current.date(byAdding: .day, value: 3, to: Date())!.toString(format: "M/dd")),
        DrawableItem(title: "에어 조던 1 로우", theme: "Vintage Grey", image: "https://s3.amazonaws.com/images.kicksfinder.com/products/large/76218e177fd437fa826c5a69a603afc5_1651683724.jpeg", href: "", monthDay: Calendar.current.date(byAdding: .day, value: 4, to: Date())!.toString(format: "M/dd")),
        DrawableItem(title: "에어 조던 1 미드", theme: "Split", image: "https://s3.amazonaws.com/images.kicksfinder.com/products/large/9f8c47b7da2619d7d21c231313931390_1660150795.jpeg", href: "", monthDay: Calendar.current.date(byAdding: .day, value: 5, to: Date())!.toString(format: "M/dd"))
        
    ]
    
    static var dummyDrawaingItems: [DrawableItem] = [
        DrawableItem(title: "에어 조던 1 로우", theme: "Psychic Purple", image: "https://s3.amazonaws.com/images.kicksfinder.com/products/large/000551d66b9d8b5e63e8cea00314c0bb_1634696915.jpeg", href: "", monthDay: Date().toString(format: "M/dd")),
        DrawableItem(title: "에어 조던 1 미드", theme: "Guava Ice/Sail-Black", image: "https://s3.amazonaws.com/images.kicksfinder.com/products/large/6ab289f04a84b455ef30bc4750ffe84d_1612718133.jpeg", href: "", monthDay: Date().toString(format: "M/dd"))
    ]
}
