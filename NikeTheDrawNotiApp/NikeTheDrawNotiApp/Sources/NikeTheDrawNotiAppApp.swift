//
//  NikeTheDrawNotiAppApp.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2022/04/18.
//

import SwiftUI

@main
struct NikeTheDrawNotiAppApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }.onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                print("active")
            case .inactive:
                print("inactive")
            case .background:
                print("background")
            @unknown default:
                print("Detected Unknown ScenePhase !!")
            }
        }
    }
}
