//
//  ParseManager.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2022/04/18.
//

import Foundation
import SwiftSoup

class ParseManager {
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
    
    /// GitHub model 소스를 파싱해 JSON 형태의 String 으로 반환합니다.
    func parseJSONString(_ html: String?) -> String? {
        var jsonString: String = ""
        
        guard let html else { return nil }
        do {
            let soup: Document = try SwiftSoup.parse(html)
            let box: Elements = try soup.select("div.Box-body")
            let lines: Elements = try box.select("td.blob-code")
            for line: Element in lines.array() {
                let text = try line.text()
                jsonString.append(text)
            }
            
            return jsonString
            
        } catch let e {
            print(#fileID, #function, #line, "error:", e)
            return nil
        }
    }
    
    /// 아이템 상세 페이지로부터 캘린더 부분을 파싱하여 [String]? 형태로 반환합니다.
    /// - Parameter html: 아이템 상세 페이지
    /// - Returns: [String]
    func parseCalendar(from html: String?) -> [String]? {
        var calendar: [String] = []
        guard let html = html else { return nil }
        do {
            let soup = try SwiftSoup.parse(html)
            let drawInfos = try soup.select("p.draw-info")
            
            for drawInfo in drawInfos {
                let text = try drawInfo.text()
                calendar.append(text)
            }
            print(#fileID, #function, #line, "calendar:", calendar)
            return calendar
        } catch let e {
            print(#fileID, #function, #line, "error:", e)
            return nil
        }
    }
    
    /// 캘린더로부터 응모 시작 시간을 파싱하여 Date 형태로 반환합니다.
    /// - Parameter calendar: 캘린더 [String]
    /// - Returns: Date
    func parseStartDate(from calendar: [String]) -> Date {
        let startDateString = calendar.first ?? ""
        // 응모 시간 :8/12(금) 10:00 ~ 10:30 (30분)
        var month = ""
        var day = ""
        var hour = ""
        var min = ""
        
        // month 추출
        if let startIndex = startDateString.endIndex(of: "응모 시간 :") {
            if let endIndex = startDateString.index(of: "/") {
                let subString = startDateString[startIndex..<endIndex]
                let subStringInt = Int(subString)!
                month = String(format: "%02d", subStringInt)
            }
        }
        // day 추출
        if let startIndex = startDateString.endIndex(of: "/") {
            if let endIndex = startDateString.index(of: "(") {
                let subString = startDateString[startIndex..<endIndex]
                let subStringInt = Int(subString)!
                day = String(format: "%02d", subStringInt)
            }
        }
        // hour & min 추출
        if let startIndex = startDateString.endIndex(of: ") ") {
            if let gijun = startDateString.index(of: "~") {
                let endIndex = startDateString.index(gijun, offsetBy: -1)
                let subString = startDateString[startIndex..<endIndex]
                let hourMin = String(subString).components(separatedBy: ":")
                let hourInt = Int(hourMin.first!)!
                let minInt = Int(hourMin.last!)!
                hour = String(format: "%02d", hourInt)
                min = String(format: "%02d", minInt)
            }
        }
        
        // 현재 year 추출
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: Date())
        
        print(year + "년", month + "월", day + "일", hour + "시", min + "분")
        
        // String -> Date 변환
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateStr = "\(year)-\(month)-\(day) \(hour):\(min)"
        
        return dateFormatter.date(from: dateStr) ?? Date()
    }
}
