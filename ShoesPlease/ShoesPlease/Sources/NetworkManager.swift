//
//  NetworkManager.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2022/04/22.
//

import Foundation
import Alamofire

class NetworkManager {
    typealias Html = String
    
    /// 현재 응모중인 아이템 목록 page html 을 가져옵니다.
    /// - Returns: Html: String
    func getLaunchItemPage() async throws -> Html {
        let url = Const.URL.baseURL + Const.URL.launchItemsURL
        return try await getPage(url: url)
    }
    
    /// 해당 아이템의 상세 page html 을 가져옵니다.
    /// - Parameter from: 상세 page 를 가져올 아이템
    /// - Returns: Html: String
    func getLaunchItemDetailPage(from item: DrawableItem) async throws -> Html {
        let url = Const.URL.baseURL + item.href
        return try await getPage(url: url)
    }
    
    func getModelPage(itemType: ItemType) async throws -> Html {
        var url: String = ""
        switch itemType {
        case ItemType.nikeReleasedItems:
            url = "https://github.com/youn9k/ShoesPlease/blob/main/models/nike/released_items.json"
        case ItemType.nikeToBeReleasedItems:
            url = "https://github.com/youn9k/ShoesPlease/blob/main/models/nike/to_be_released_items.json"
        }
        return try await getPage(url: url)
    }
    
    private func getPage(url: String) async throws -> String {
        guard let url = URL(string: url) else { return "" }
        let (data, _) = try await URLSession.shared.data(from: url)
        return String(data: data, encoding: .utf8) ?? ""
    }
    
}
