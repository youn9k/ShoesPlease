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
    
    var subscription = Set<AnyCancellable>()
    var refreshActionSubject = PassthroughSubject<(), Never>()
    
    init() {
        print(drawableItems)
        refreshActionSubject.sink { [weak self] _ in
            //self?.request(path: Const.URL.launchItemsURL)
            self?.testGetDrawableItems()
            //self?.setDummyDrawableItems()// 더미 데이터 불러오기
        }.store(in: &subscription)
    }
    
    func request(path: String = "/kr") {
        AF.request(Const.URL.baseURL + path,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: Const.headers)
        .validate(statusCode: 200..<300)
        .publishString()
        .compactMap{ $0.value }
        .sink(receiveCompletion: { completion in
            print("수신 완료")
            self.testString = "수신 완료"
        }, receiveValue: { [weak self] receivedValue in
            print("받은 값:", receivedValue)
            let items = self?.parseManager.getDrawableItems(receivedValue)
            self?.setDrawableItems(items: items)
        }).store(in: &subscription)
    }
    
    func setDrawableItems(items: [DrawableItem]?) {
        self.drawableItems = items ?? []
    }
    
    func setDummyDrawableItems() {
        self.drawableItems = DrawableItem.dummyDrawableItems
    }
    
    func testGetDrawableItems() {
        networkManager.request(url: Const.URL.baseURL + Const.URL.launchItemsURL) { [weak self] result in
            switch result {
            case .success(let html):
                print("수신 완료")
                self?.testString = "수신 완료"
                let items = self?.parseManager.getDrawableItems(html)
                self?.setDrawableItems(items: items)
            case .failure(let error):
                print(#fileID, #function, #line, "error:", error)
            }
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
}
