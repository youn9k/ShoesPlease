//
//  ReleasedItem.swift
//  ShoesPlease
//
//  Created by YoungK on 2022/11/12.
//

import Foundation

/// 출시된 아이템
struct ReleasedItem: Identifiable, Codable {
    var id = UUID()
    let title: String
    let theme: String
    let image: String
    let href: String
    var date: String // ex) "9/14"
}

extension ReleasedItem {
    static var dummyReleasedItems: [ReleasedItem] = [
        ReleasedItem(title: "에어 조던 1 로우",
                     theme: "Psychic Purple",
                     image: "https://s3.amazonaws.com/images.kicksfinder.com/products/large/000551d66b9d8b5e63e8cea00314c0bb_1634696915.jpeg",
                     href: "",
                     date: Date().toString(format: "M/dd")),
        ReleasedItem(title: "에어 조던 1 미드",
                     theme: "Guava Ice/Sail-Black",
                     image: "https://s3.amazonaws.com/images.kicksfinder.com/products/large/6ab289f04a84b455ef30bc4750ffe84d_1612718133.jpeg",
                     href: "",
                     date: Date().toString(format: "M/dd"))
    ]
}
