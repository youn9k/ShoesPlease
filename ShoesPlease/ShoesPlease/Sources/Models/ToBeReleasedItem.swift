//
//  ToBeReleasedItem.swift
//  ShoesPlease
//
//  Created by YoungK on 2022/11/12.
//

import Foundation

/// 출시 예정 아이템
struct ToBeReleasedItem: Identifiable {
    var id = UUID()
    let title: String
    let theme: String
    let image: String
    let href: String
    var date: String // ex) "9/14"
    var releasedDate: String // ex) "2022-09-14 01:00"
}
