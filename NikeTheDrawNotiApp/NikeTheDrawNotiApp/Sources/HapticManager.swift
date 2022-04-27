//
//  HapticManager.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2022/04/27.
//

import Foundation
import UIKit

class HapticManager {
    static let instance = HapticManager()
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    // 사용법
    // HapticManager.instance.notification(type: .warning)
    // HapticManager.instance.notification(type: .error)
    // HapticManager.instance.notification(type: .success)
    // HapticManager.instance.impact(style: .heavy)
    // HapticManager.instance.impact(style: .light)
    // HapticManager.instance.impact(style: .medium)
    // HapticManager.instance.impact(style: .rigid)
    // HapticManager.instance.impact(style: .soft)
}

