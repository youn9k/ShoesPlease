//
//  MainViewModel.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2022/04/18.
//

import Foundation
import SwiftSoup
import Alamofire
import Combine

class MainViewModel: ObservableObject {
    var parseManager = ParseManager()
    var networkManager = NetworkManager()
    
    @Published var testString = "수신 전"
    @Published var drawableItems = [DrawableItem]()
    @Published var isRefreshing = false
    
    var subscription = Set<AnyCancellable>()
    var refreshActionSubject = PassthroughSubject<(), Never>()
    
    init() {
        print("vm init")
        refreshActionSubject.sink { [weak self] _ in
            HapticManager.instance.impact(style: .medium)
            self?.fetchDrawableItems()
            //self?.setDummyDrawableItems()// 더미 데이터 불러오기
        }.store(in: &subscription)
    }
    
    deinit { print("vm deinit") }
   
    func setDrawableItems(items: [DrawableItem]?) {
        self.drawableItems = items ?? []
    }
    
    func setDummyDrawableItems() {
        self.drawableItems = DrawableItem.dummyDrawableItems
    }
    
    func fetchDrawableItems() {
        networkManager.request(url: Const.URL.baseURL + Const.URL.launchItemsURL) { [weak self] result in
            switch result {
            case .success(let html):
                HapticManager.instance.notification(type: .success)
                print("수신 완료")
                self?.testString = "수신 완료"
                let items = self?.parseManager.parseDrawableItems(html)
                self?.setDrawableItems(items: items)
            case .failure(let error):
                HapticManager.instance.notification(type: .error)
                print(#fileID, #function, #line, "error:", error)
            }
            print(#fileID, #function, #line, "새로고침 끝")
            self?.isRefreshing = false
        }
    }
    
//    func testGetCalendar() {
//        networkManager.request(url: Const.URL.baseURL + drawableItems) { [weak self] result in
//            switch result {
//            case .success(let html):
//                let items = self?.parseManager.getDrawableItems(html)
//                self?.setDrawableItems(items: items)
//            case .failure(let error):
//                print(#fileID, #function, #line, "error:", error)
//            }
//        }
//    }
    
    func addEvent(date: Date, title: String, theme: String) {
        let eventName = title + " " + theme + " " + "응모"
        HapticManager.instance.impact(style: .light)
        EventManager.instance.addEvent(startDate: date.addingTimeInterval(60), eventName: eventName)
    }
}
