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
    
    @Published var testString = "수신 전"
    @Published var drawableItems = [DrawableItem]()
    
    var subscription = Set<AnyCancellable>()
    var refreshActionSubject = PassthroughSubject<(), Never>()
    
    init() {
        print(drawableItems)
        //request(path: Const.URL.launchItemsURL)
        refreshActionSubject.sink { [weak self] _ in
            self?.request(path: Const.URL.launchItemsURL)
            //self?.setDummyDrawableItems()
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
}
