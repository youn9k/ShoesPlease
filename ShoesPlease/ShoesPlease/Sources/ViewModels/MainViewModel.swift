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
            HapticManager.shared.impact(style: .medium)
            self?.fetchDrawableItems()
        }.store(in: &subscription)
    }
    
    deinit { print("vm deinit") }
   
    func setDrawableItems(items: [DrawableItem]?) {
        self.drawableItems = items ?? []
    }
    
    /// 응모 시작 전인 아이템들을 가져옵니다.
    func fetchDrawableItems() {
        Task {
            let html = try await networkManager.getLaunchItemPage()
            self.isRefreshing = false
            let items = parseManager.parseDrawableItems(html)
            setDrawableItems(items: items)
        }
    }
    
    /// 해당 아이템의 응모시작시간을 캘린더에 등록합니다.
    /// - Parameter item: 캘린더에 등록할 아이템
    func addEvent(item: DrawableItem) async throws -> Bool {
        print("🔨VM: addEvent를 호출합니다.")
        let eventName = item.title + " " + item.theme + " " + "응모"
        let startDate = try await getStartDate(item: item)
        let isSuccess = try await EventManager.shared.addEvent(startDate: startDate, eventName: eventName)
        isSuccess ? HapticManager.shared.notification(type: .success) : HapticManager.shared.notification(type: .error)
        return isSuccess
    }
    
    /// item 의 응모시작시간을 반환합니다.
    /// - Parameter item: 응모시작시간을 추출할 item
    func getStartDate(item: DrawableItem) async throws -> Date {
        let html = try await networkManager.getLaunchItemDetailPage(from: item)
        guard let calendar = parseManager.parseCalendar(from: html) else { return Date() }
        return parseManager.parseStartDate(from: calendar)
    }
}

// MARK: - 더미 데이터와 관련된 익스텐션입니다.
extension MainViewModel {
    func setDummyDrawableItems() {
        self.drawableItems = DrawableItem.dummyDrawableItems
    }
    func getDummyStartDate(item: DrawableItem) -> Date {
        item.startDate ?? Date()
    }
}
