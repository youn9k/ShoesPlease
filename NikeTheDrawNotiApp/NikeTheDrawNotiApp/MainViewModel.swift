//
//  MainViewModel.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2022/04/18.
//

import Foundation
import SwiftSoup
import Alamofire

class MainViewModel {
    var parseManager = ParseManager()
    
    @Published var testString = "testString"
    
    let ROOT_URL = "https://www.nike.com"
    
    init() {
        request(path: "/kr/launch?type=upcoming&activeDate=date-filter:AFTER")
    }
    
    func request(path: String = "/kr") -> Void {
        AF.request(ROOT_URL + path,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["user-agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 11_0_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.272 Whale/2.9.118.16 Safari/537.36"])
        .validate(statusCode: 200..<300)
        .responseString { [weak self] response in
            guard let self = self else { return }
            let html = self.parseManager.soup(response.value)
            
            print(html ?? "없습니당")
        }
    }

}
