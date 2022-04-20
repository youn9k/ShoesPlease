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

class MainViewModel {
    var parseManager = ParseManager()
    
    @Published var testString = "testString"
    @Published var drawableItems = [DrawableItem]()
    
    var subscription = Set<AnyCancellable>()
    
    init() {
        request(path: "/kr/launch?type=upcoming&activeDate=date-filter:AFTER")
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
        }, receiveValue: { receivedValue in
            print("받은 값:", receivedValue)
            self.parseManager.getDrawableItems(receivedValue)
        }).store(in: &subscription)
    }

}
