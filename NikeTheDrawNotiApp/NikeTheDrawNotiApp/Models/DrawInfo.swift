//
//  DrawInfo.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2021/09/07.
//

import Foundation

class DrawInfo {
    let imageURL: String? // 이미지 링크
    let modelName: String? // 모델명
    let releaseDate: String? // 응모 일정
    
    init(imageURL: String, modelName: String, releaseDate: String) {
        self.imageURL = imageURL
        self.modelName = modelName
        self.releaseDate = releaseDate
    }
}
