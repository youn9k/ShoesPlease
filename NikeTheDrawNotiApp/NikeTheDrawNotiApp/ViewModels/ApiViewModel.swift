//
//  ApiViewModel.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2021/09/12.
//

import Foundation
import Alamofire
import SwiftSoup

class ApiViewModel {
    let api = Api()
    // var response: DataRequest
    
    // 테이블 뷰 셀에 넣을 카드들을 가져오는 함수입니다.
    func getDrawableItems() {
        print(api.request())
        //api.launchItem()
    }
    
    // 테스트용
    func testDrawableItems() {
        let urlAddress = "https://www.nike.com/kr"
        guard let url = URL(string: urlAddress) else { return }
        do {
            let html = try String(contentsOf: url, encoding: .utf8)
            let doc = try SwiftSoup.parse(html)
            print(doc)
            
        } catch let error {
            print("error: ", error)
        }
    }
    
}
