//
//  Enum.swift
//  ShoesPlease
//
//  Created by YoungK on 2022/09/20.
//

import Foundation
import SwiftUI

enum ScreenSize {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
}
enum MainViewType: String, CaseIterable {
    case carousel = "rectangle.portrait.split.2x1"
    case list = "square.split.1x2"
}
