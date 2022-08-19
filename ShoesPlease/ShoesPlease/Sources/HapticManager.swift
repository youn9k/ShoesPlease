//
//  HapticManager.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2022/04/27.
//

import Foundation
import UIKit

class HapticManager {
    static let shared = HapticManager()
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    // 사용법
    // HapticManager.shared.notification(type: .warning)
    // HapticManager.shared.notification(type: .error)
    // HapticManager.shared.notification(type: .success)
    // HapticManager.shared.impact(style: .heavy)
    // HapticManager.shared.impact(style: .light)
    // HapticManager.shared.impact(style: .medium)
    // HapticManager.shared.impact(style: .rigid)
    // HapticManager.shared.impact(style: .soft)
}

