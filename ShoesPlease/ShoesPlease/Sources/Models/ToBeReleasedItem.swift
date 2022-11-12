//
//  ToBeReleasedItem.swift
//  ShoesPlease
//
//  Created by YoungK on 2022/11/12.
//

import Foundation

/// 출시 예정 아이템
struct ToBeReleasedItem: Identifiable, Codable {
    var id = UUID()
    let title: String
    let theme: String
    let image: String
    let href: String
    var date: String // ex) "9/14"
    var releasedDate: String // ex) "2022-09-14 01:00"
}

extension ToBeReleasedItem {
    static var dummyToBeReleasedItems: [ToBeReleasedItem] = [
        ToBeReleasedItem(title: "에어 조던 1 레트로 하이 OG",
                         theme: "Taxi",
                         image: "https://s3.amazonaws.com/images.kicksfinder.com/products/large/6a617d0e09c64052861f4c636ebfa481_1658956605.jpeg",
                         href: "",
                         date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!.toString(format: "M/dd"),
                         releasedDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!.toString(format: "yyyy-MM-dd hh:mm")),
        ToBeReleasedItem(title: "에어 조던 1 미드",
                         theme: "Multi-Color",
                         image: "https://s3.amazonaws.com/images.kicksfinder.com/products/large/16432b8a79bf1464ba9053905f49f156_1650292822.jpeg",
                         href: "",
                         date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!.toString(format: "M/dd"),
                         releasedDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!.toString(format: "yyyy-MM-dd hh:mm")),
        ToBeReleasedItem(title: "에어 조던 1 하이",
                         theme: "White/Daybreak",
                         image: "https://s3.amazonaws.com/images.kicksfinder.com/products/large/bf6aa63b01a982465f7efa0f1c5f466a_1612887362.jpeg",
                         href: "",
                         date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!.toString(format: "M/dd"),
                         releasedDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!.toString(format: "yyyy-MM-dd hh:mm")),
        ToBeReleasedItem(title: "에어 조던 1 로우",
                         theme: "Vintage Grey",
                         image: "https://s3.amazonaws.com/images.kicksfinder.com/products/large/76218e177fd437fa826c5a69a603afc5_1651683724.jpeg",
                         href: "",
                         date: Calendar.current.date(byAdding: .day, value: 4, to: Date())!.toString(format: "M/dd"),
                         releasedDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!.toString(format: "yyyy-MM-dd hh:mm")),
        ToBeReleasedItem(title: "에어 조던 1 미드",
                         theme: "Split",
                         image: "https://s3.amazonaws.com/images.kicksfinder.com/products/large/9f8c47b7da2619d7d21c231313931390_1660150795.jpeg",
                         href: "",
                         date: Calendar.current.date(byAdding: .day, value: 5, to: Date())!.toString(format: "M/dd"),
                         releasedDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!.toString(format: "yyyy-MM-dd hh:mm"))
    ]
}

