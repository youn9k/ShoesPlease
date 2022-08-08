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
    
    func addEvent(item: DrawableItem) {
        let eventName = item.title + " " + item.theme + " " + "응모"
        getCalendar(itemURL: item.href) { startDate in
            HapticManager.instance.impact(style: .soft)
            EventManager.instance.addEvent(startDate: startDate, eventName: eventName)
        }
    }
    
    func getCalendar(itemURL: String, completion: @escaping (_ startDate: Date) -> Void) {
        networkManager.request(url: Const.URL.baseURL + itemURL) { [weak self] result in
            switch result {
            case .success(let html):
                print(#fileID, #function, #line, "getCalendar 성공")
                let calendar = self?.parseManager.parseCalendar(html)
                if let calendar = calendar {
                    let startDate = self?.parseManager.parseStartDate(from: calendar)
                    completion(startDate ?? Date())
                }
                
            case .failure(let error):
                HapticManager.instance.notification(type: .error)
                print(#fileID, #function, #line, "error:", error)
            }
            print(#fileID, #function, #line, "getCalendar 끝")
        }
    }
}
