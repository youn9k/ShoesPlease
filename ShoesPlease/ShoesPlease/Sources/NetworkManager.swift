//
//  NetworkManager.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2022/04/22.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkManager {
    static let shared = NetworkManager()
    typealias Html = String
    
    /// 출시된 아이템들을 가져옵니다.
    /// - Parameter at: CompanyType
    /// - Returns: JSON : SwiftyJSON
    func getReleasedItems(at companyType: CompanyType) async throws -> JSON {
        var company: String = ""
        switch companyType {
        case .nike:
            company = "/nike"
        case .newBalance:
            company = "/new_balance"
        }
        
        let url = Const.URL.models + company + "/released_items.json"
        
        let output: (Data, URLResponse) = try await URLSession.shared.data(from: URL(string: url)!)
        let data: Data = try validateOutput(output: output, url: url)
        
        let jsonDatas = JSON(parseJSON: String(data: data, encoding: .utf8)!)
        return jsonDatas
    }
    
    /// 출시 예정인 아이템들을 가져옵니다.
    /// - Parameter at: CompanyType
    /// - Returns: JSON : SwiftyJSON
    func getToBeReleasedItems(at companyType: CompanyType) async throws -> JSON {
        var company: String = ""
        switch companyType {
        case .nike:
            company = "/nike"
        case .newBalance:
            company = "/new_balance"
        }
        
        let url = Const.URL.models + company + "/to_be_released_items.json"
        
        let output: (Data, URLResponse) = try await URLSession.shared.data(from: URL(string: url)!)
        let data: Data = try validateOutput(output: output, url: url)
        
        let jsonDatas = JSON(parseJSON: String(data: data, encoding: .utf8)!)
        return jsonDatas
    }
    
    
}


extension NetworkManager {
    private func validateOutput(output: (Data, URLResponse), url: String) throws -> Data {
        guard let response = output.1 as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.0
    }
}
