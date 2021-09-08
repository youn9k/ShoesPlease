//
//  DrawInfo.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2021/09/07.
//

import Foundation

class DrawInfo {
    let imageURL: String?
    let modelName: String?
    let releaseDate: String?
    
    init(imageURL: String, modelName: String, releaseDate: String) {
        self.imageURL = imageURL
        self.modelName = modelName
        self.releaseDate = releaseDate
    }
}
