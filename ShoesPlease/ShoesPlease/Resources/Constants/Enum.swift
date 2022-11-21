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

enum CompanyType {
    case nike, newBalance
}

enum NetworkingError: LocalizedError {
    case badURLResponse(url: String)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .badURLResponse(url: let url):
            return "[🔥] Bad response from URL: \(url)"
        case .unknown:
            return "[❓] Unknown error occured"
        }
    }
}
