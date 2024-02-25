//
//  MainViewModel.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2022/04/18.
//

import Foundation
import Combine
import Alamofire
import SwiftyJSON

class MainViewModel: ObservableObject {
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
            //self?.fakeRefresh()
            self?.fetchData()
            
            #else
            self?.fetchData()
            #endif
        }.store(in: &subscription)
        
        $isRefreshing.sink { isRefreshing in
            print("✅ isRefreshing:", isRefreshing)
        }.store(in: &subscription)
        
        isRefreshing = true
        #if DEBUG
        //setDummyReleasedItems()
        //setDummyToBeReleasedItems()
        fetchData()
        #else
        fetchData()
        #endif
        
        
    }
    
    deinit { print("vm deinit") }
    
    func fetchData() {
        print("✅ fetchData called !")
        Task {
            HapticManager.shared.impact(style: .medium)
            
            var isSuccessed = try await fetchReleasedItems()
            isSuccessed = try await fetchToBeReleasedItems()
            
            HapticManager.shared.notification(success: isSuccessed)
            
            //  refreshing 애니메이션이 끝나기전에 false 가 되버리면 refreshAction을 다시 호출해버림
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                self.isRefreshing = false
            }
        }
    }
    
}

// MARK: - 메소드들을 모아놓은 익스텐션입니다.
extension MainViewModel {
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
    func fetchReleasedItems() async throws -> Bool {
        print("fetchReleasedItems called")
        
        var releasedItems: [ReleasedItem] = []
        
        let jsons = try await NetworkManager.shared.getReleasedItems(at: .nike)
        for (_, subJSON) : (String, JSON) in jsons {
            guard let title = subJSON["title"].string,
                  let theme = subJSON["theme"].string,
                  let image = subJSON["image"].string,
                  let href = subJSON["href"].string,
                  let date = subJSON["date"].string
            else { continue }
            
            let convertedDate = (date.toDate(format: "MM월 dd일") ?? Date()).toString(format: "MM월 dd일")
            
            releasedItems.append(ReleasedItem(title: title, theme: theme, image: image, href: href, date: convertedDate))
        }
        
        let isSuccess = setReleasedItems(items: releasedItems)
        return isSuccess
    }
    
    /// 출시 예정인 아이템들을 가져옵니다.
    func fetchToBeReleasedItems() async throws -> Bool {
        print("fetchToBeReleasedItems called")
        
        var toBeReleasedItems: [ToBeReleasedItem] = []
        
        let jsons = try await NetworkManager.shared.getToBeReleasedItems(at: .nike)
        for (_, subJSON) : (String, JSON) in jsons {
            guard let title = subJSON["title"].string,
                  let theme = subJSON["theme"].string,
                  let image = subJSON["image"].string,
                  let href = subJSON["href"].string,
                  let date = subJSON["date"].string,
                  let releaseDate = subJSON["releaseDate"].string
            else { continue }
            
            let convertedReleaseDate = Double(releaseDate)?.toString(locale: "ko_KR") ?? "" // 타임스탬프 -> "yyyy-MM-dd HH:mm"
            
            toBeReleasedItems.append(ToBeReleasedItem( title: title, theme: theme, image: image, href: href, date: date, releaseDate: convertedReleaseDate.isEmpty ? "미정" : convertedReleaseDate))
        }
        
        let isSuccess = setToBeReleasedItems(items: toBeReleasedItems)
        return isSuccess
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
