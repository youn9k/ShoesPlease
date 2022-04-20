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
    
    func getDrawableItems(_ html: String?) -> [DrawableItem]? {
        var drawableItems: [DrawableItem] = []
        guard let html = html else { return nil }
        do {
            let soup = try SwiftSoup.parse(html)
            let launchItems = try soup.select("div.product-card")
            try launchItems.forEach { launchItem in
                let launchItemText = try launchItem.text()
                let soldoutButton = try launchItem.select("a.ncss-btn-primary-dark")
                let soldoutButtonText = try soldoutButton.text()
                if try soldoutButton.text() == "THE DRAW 진행예정" {
                    print("launchItem:", launchItemText, "button:", soldoutButtonText)
                    
                    let launchItemInfo = try launchItem.select("a.comingsoon")
                    let launchItemImage = try launchItem.select("img.img-component")
                    
                    let launchItemTitle = try launchItemInfo.attr("title")
                    let launchItemImageSrc = try launchItemImage.attr("data-src")
                    let launchItemTheme = try launchItemImage.attr("alt")
                    let launchItemHref = try launchItemInfo.attr("href")
                    
                    print("title:", launchItemTitle, "theme", launchItemTheme, "image", launchItemImageSrc, "href", launchItemHref)
                    
                    drawableItems.append(DrawableItem(
                        title: launchItemTitle,
                        theme: launchItemTheme,
                        image: launchItemImageSrc,
                        href: launchItemHref)
                    )
                }
            }
           return drawableItems
        } catch let e {
            print("error: ", e)
            return nil
        }
    }
    
}
