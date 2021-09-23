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
    
    let headers: HTTPHeaders = [
        "user-agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 11_0_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.272 Whale/2.9.118.16 Safari/537.36"
    ]
    
    func request(path: String = "/kr/ko_kr") {
        AF.request(ROOT_URL + path,
                    method: .get,
                    parameters: nil,
                    encoding: URLEncoding.default,
                    headers: headers)
            .validate(statusCode: 200..<300) // 상태코드 200 ~ 300 사이만 허용
            .responseString { response in
                //guard let html = response.value else { return }
                // 여기서 response 를 활용
                print(response.data)
            }
    }
    
    

}

