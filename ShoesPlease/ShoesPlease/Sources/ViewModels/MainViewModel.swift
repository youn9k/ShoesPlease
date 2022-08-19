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
    var drawStartDate = Date()// 드로우 시작시간
    
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

//    이전 completion 방식
//    func fetchDrawableItems() {
//        networkManager.request(url: Const.URL.baseURL + Const.URL.launchItemsURL) { [weak self] result in
//            switch result {
//            case .success(let html):
//                HapticManager.instance.notification(type: .success)
//                print("수신 완료")
//                self?.testString = "수신 완료"
//                let items = self?.parseManager.parseDrawableItems(html)
//                self?.setDrawableItems(items: items)
//            case .failure(let error):
//                HapticManager.instance.notification(type: .error)
//                print(#fileID, #function, #line, "error:", error)
//            }
//            print(#fileID, #function, #line, "새로고침 끝")
//            self?.isRefreshing = false
//        }
//    }
    
    func fetchDrawableItems() {
        networkManager.fetchLaunchItemPage().sink { completion in
            switch completion {
            case .failure(let error):
                HapticManager.instance.notification(type: .error)
                print(#fileID, #function, #line, "error:", error)
            case .finished:
                HapticManager.instance.notification(type: .success)
                print(#fileID, #function, #line, "새로고침 완료")
                self.testString = "새로고침 완료"
                self.isRefreshing = false
            }
        } receiveValue: { html in
            let items = self.parseManager.parseDrawableItems(html)
            self.setDrawableItems(items: items)
        }.store(in: &subscription)
    }
    
    func addEvent(item: DrawableItem) {
        let eventName = item.title + " " + item.theme + " " + "응모"
        getStartDate(item: item)
        HapticManager.instance.impact(style: .soft)
        EventManager.instance.addEvent(startDate: drawStartDate, eventName: eventName)
    }
    
//    func getCalendar(itemURL: String, completion: @escaping (_ startDate: Date) -> Void) {
//        networkManager.request(url: Const.URL.baseURL + itemURL) { [weak self] result in
//            switch result {
//            case .success(let html):
//                print(#fileID, #function, #line, "getCalendar 성공")
//                let calendar = self?.parseManager.parseCalendar(from: html)
//                if let calendar = calendar {
//                    let startDate = self?.parseManager.parseStartDate(from: calendar)
//                    completion(startDate ?? Date())
//                }
//
//            case .failure(let error):
//                HapticManager.instance.notification(type: .error)
//                print(#fileID, #function, #line, "error:", error)
//            }
//            print(#fileID, #function, #line, "getCalendar 끝")
//        }
//    }
    
    func getStartDate(item: DrawableItem) {
        networkManager.fetchLaunchItemDetailPage(from: item).sink { completion in
            switch completion {
            case .failure(let error):
                HapticManager.instance.notification(type: .error)
                print(#fileID, #function, #line, "error:", error)
            case .finished:
                HapticManager.instance.notification(type: .success)
                print(#fileID, #function, #line, "finished")
            }
            
        } receiveValue: { [weak self] html in
            /// 1. receiveValue 로 아이템의 상세 페이지 html을 전달 받음
            /// 2. html 로부터 캘린더 부분을 파싱
            /// 3. 캘린더로부터 응모시작시간 파싱
            let calendar = self?.parseManager.parseCalendar(from: html)
            if let calendar = calendar {
                self?.drawStartDate = self?.parseManager.parseStartDate(from: calendar) ?? Date()
            }
        }.store(in: &subscription)
    }
}
