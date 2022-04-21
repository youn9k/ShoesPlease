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
