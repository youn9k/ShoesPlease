//
//  NetworkManager.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2022/04/22.
//

import Foundation
import Alamofire
import Combine

class NetworkManager {
    typealias Html = String
    
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
    
    /// 현재 응모중인 아이템 목록 page html 을 가져옵니다.
    /// - Returns: Html: String
    func fetchLaunchItemPage() -> AnyPublisher<Html, Error> {
        let url = URL(string: Const.URL.baseURL + Const.URL.launchItemsURL)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map{ $0.data }
            .compactMap{ String(data: $0, encoding: .utf8) }
            .mapError{ error in fatalError("\(error)") }
            .eraseToAnyPublisher()
    }
    
    /// 해당 아이템의 상세 page html 을 가져옵니다.
    /// - Parameter from: 상세 page 를 가져올 아이템
    /// - Returns: Html: String
    func fetchLaunchItemDetailPage(from item: DrawableItem) -> AnyPublisher<Html, Error> {
        let url = URL(string: Const.URL.baseURL + item.href)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map{ $0.data }
            .compactMap{ String(data: $0, encoding: .utf8) }
            .mapError{ error in fatalError("\(error)") }
            .eraseToAnyPublisher()
    }
    
}
