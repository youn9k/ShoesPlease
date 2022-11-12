//
//  MainViewModel.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2022/04/18.
//

import Foundation
import Combine
import Alamofire
import SwiftSoup
import SwiftyJSON

class MainViewModel: ObservableObject {
    var parseManager = ParseManager()
    var networkManager = NetworkManager()
    
    @Published var testString = "수신 전"
    @Published var releasedItems = [ReleasedItem]()
    @Published var toBeReleasedItems = [ToBeReleasedItem]()
    @Published var isRefreshing = false
    
    var subscription = Set<AnyCancellable>()
    var refreshActionSubject = PassthroughSubject<(), Never>()
    
    init() {
        print("vm init")
        refreshActionSubject.sink { [weak self] _ in
            #if DEBUG
//            self?.fakeRefresh()
//            self?.fetchReleasedItems()
            self?.fetchReleasedItems()
            self?.fetchToBeReleasedItems()
            #else
            self?.fetchReleasedItems()
            self?.fetchToBeReleasedItems()
            #endif
        }.store(in: &subscription)
        
        #if DEBUG
//        setDummyReleasedItems()
//        setDummyToBeReleasedItems()
        fetchReleasedItems()
        fetchToBeReleasedItems()
        #else
        fetchReleasedItems()
        fetchToBeReleasedItems()
        #endif
    }
    
    deinit { print("vm deinit") }
   
    /// 출시 예정인 아이템들을 등록합니다.
    func setToBeReleasedItems(items: [ToBeReleasedItem]?) -> Bool {
        guard let items = items else { return false }
        self.toBeReleasedItems = items
        return true
    }
    
    /// 출시된 아이템들을 등록합니다.
    func setReleasedItems(items: [ReleasedItem]?) -> Bool {
        guard let items = items else { return false }
        self.releasedItems = items
        return true
    }
    
    /// 출시된 아이템들을 가져옵니다.
    func fetchReleasedItems() {
        print("fetchReleasedItems called")
        Task {
            var releasedItems: [ReleasedItem] = []
            
            isRefreshing = true
            HapticManager.shared.impact(style: .medium)
            
            let html = try await networkManager.getModelPage(itemType: .nikeReleasedItems) // 1. 깃헙 내 모델 html 가져옴
            let jsonString = parseManager.parseJSONString(html) // 2. html 로부터 json 부분 파싱
            let jsons = JSON(parseJSON: jsonString ?? "") // 3. json으로 변환
            
            for (_, subJSON) : (String, JSON) in jsons {
                guard let title = subJSON["title"].string,
                      let theme = subJSON["theme"].string,
                      let image = subJSON["image"].string,
                      let href = subJSON["href"].string,
                      let date = subJSON["date"].string
                else { continue }
                
                releasedItems.append(ReleasedItem(title: title, theme: theme, image: image, href: href, date: date))
            }
                    
            let isSuccess = setReleasedItems(items: releasedItems)
            
            self.isRefreshing = false
            HapticManager.shared.notification(success: isSuccess)
        }
    }
    
    /// 출시 예정인 아이템들을 가져옵니다.
    func fetchToBeReleasedItems() {
        print("fetchToBeReleasedItems called")
        Task {
            var toBeReleasedItems: [ToBeReleasedItem] = []
            
            isRefreshing = true
            HapticManager.shared.impact(style: .medium)
            
            let html = try await networkManager.getModelPage(itemType: .nikeToBeReleasedItems) // 1. 깃헙 내 모델 html 가져옴
            let jsonString = parseManager.parseJSONString(html) // 2. html 로부터 json 부분 파싱
            let jsons = JSON(parseJSON: jsonString ?? "") // 3. json으로 변환
            
            for (_, subJSON) : (String, JSON) in jsons {
                guard let title = subJSON["title"].string,
                      let theme = subJSON["theme"].string,
                      let image = subJSON["image"].string,
                      let href = subJSON["href"].string,
                      let date = subJSON["date"].string,
                      let releasedDate = subJSON["releaseDate"].string
                else { continue }
                
                toBeReleasedItems.append(ToBeReleasedItem(title: title, theme: theme, image: image, href: href, date: date, releaseDate: releasedDate))
            }
            
            let isSuccess = setToBeReleasedItems(items: toBeReleasedItems)
            
            self.isRefreshing = false
            HapticManager.shared.notification(success: isSuccess)
        }
    }
    
    /// 해당 아이템의 응모시작시간을 캘린더에 등록합니다.
    /// - Parameter item: 캘린더에 등록할 아이템
    func addEvent(name: String, date: Date) async throws -> Bool {
        print("🔨VM: addEvent를 호출합니다.")
        
        let isSuccess = try await EventManager.shared.addEvent(startDate: date, eventName: name)
        HapticManager.shared.notification(success: isSuccess)
        return isSuccess
    }
}

// MARK: - 더미 데이터와 관련된 익스텐션입니다.
extension MainViewModel {
    func setDummyToBeReleasedItems() {
        self.toBeReleasedItems = ToBeReleasedItem.dummyToBeReleasedItems
    }
    func setDummyReleasedItems() {
        self.releasedItems = ReleasedItem.dummyReleasedItems
    }
    
    func fakeRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { [weak self] in
            self?.isRefreshing = false
            HapticManager.shared.notification(success: false)
        }
    }
}
