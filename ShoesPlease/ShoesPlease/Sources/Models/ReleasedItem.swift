//
//  ReleasedItem.swift
//  ShoesPlease
//
//  Created by YoungK on 2022/11/12.
//

import Foundation

/// 출시된 아이템
struct ReleasedItem: Identifiable {
    var id = UUID()
    let title: String
    let theme: String
    let image: String
    let href: String
    var date: String // ex) "9/14"
}
