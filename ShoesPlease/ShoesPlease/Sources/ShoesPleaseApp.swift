//
//  NikeTheDrawNotiAppApp.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2022/04/18.
//

import SwiftUI

@main
struct ShoesPleaseApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear {
                    #if DEBUG
                    print("DEBUG 모드입니다.")
                    #else
                    print("RELEASE 모드입니다.")
                    #endif
                }
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
