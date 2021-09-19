//
//  Api.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2021/09/10.
//

import Foundation
import SwiftSoup
import Alamofire

class Api {
    let ROOT_URL = "https://www.nike.com"
    
    func request(path: String = "/kr") -> DataRequest {
        let response = AF.request(ROOT_URL + path,
                                  method: .get,
                                  parameters: nil,
                                  encoding: URLEncoding.default,
                                  headers: ["user-agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 11_0_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.272 Whale/2.9.118.16 Safari/537.36"])
                        .validate(statusCode: 200..<300)
        return response
    }
    
    func soup(response: DataRequest) -> Document {
        return SwiftSoup.parse(<#String#>)
    }
    
    // 게시되어 있는 카드들을 가져오는 함수입니다.
    func launchItem() -> DrawInfo {
        
        return DrawInfo(imageURL: "urlTest", modelName: "nameTest", releaseDate: "dateTest")
    }

}

