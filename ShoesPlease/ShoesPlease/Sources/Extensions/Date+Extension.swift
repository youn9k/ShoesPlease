//
//  Date+Extension.swift
//  ShoesPlease
//
//  Created by YoungK on 2022/09/21.
//

import Foundation

extension Date {
    /// Date 를 String 으로 변환합니다.
    /// - Parameter format: 원하는 변환 형식 ex) "M/dd"
    /// - Returns: String: ex) "9/14"
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let dateString = formatter.string(from: self)
        return dateString
    }
}
