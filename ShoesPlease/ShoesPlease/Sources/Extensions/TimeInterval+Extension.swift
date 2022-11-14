//
//  TimeInterval+Extension.swift
//  ShoesPlease
//
//  Created by YoungK on 2022/11/14.
//

import Foundation

extension TimeInterval {
    
    /// 타임스탬프를 "2023-09-14 06:00" 형태로 변환하는 함수입니다.
    func toString(locale: String) -> String? {

     let dateFormatter = DateFormatter()

     dateFormatter.locale = Locale(identifier: locale) // "ko_KR"

     dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

     let date = Date(timeIntervalSince1970: self)

     return dateFormatter.string(from: date)

    }
}
