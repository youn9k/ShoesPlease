//
//  NetworkManager.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2022/04/22.
//

import Foundation
import Alamofire

class NetworkManager {
    
    func request(url: String, completion: @escaping (Result<String, AFError>) -> Void) {
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: Const.headers)
        .validate(statusCode: 200..<300)
        .responseString { response in
            switch response.result {
            case .success(let html):
                completion(.success(html))
            case . failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func request2(url: String) -> DataResponsePublisher<String> {
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: Const.headers)
        .validate(statusCode: 200..<300)
        .publishString()
    }
}
