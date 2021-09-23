//
//  ParseManager.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2021/09/23.
//

import Foundation
import SwiftSoup

class ParseManager {
    let api = Api()
    
    // 문자열을 soup 으로 만들어주는 함수입니다.
    func soup(_ html: String?) -> Document? {
        guard let html = html else { return nil }
        do {
            let soup = try SwiftSoup.parse(html)
            return soup
        } catch let e {
            print("error: ", e)
            return nil
        }
    }
    
    // 게시되어 있는 카드들을 가져오는 함수입니다.
    func launchItem() -> DrawInfo {
        api.request(path: "/kr/launch?type=upcoming&activeDate=date-filter:AFTER")
        
        return DrawInfo(imageURL: "urlTest", modelName: "nameTest", releaseDate: "dateTest")
    }
    
}
