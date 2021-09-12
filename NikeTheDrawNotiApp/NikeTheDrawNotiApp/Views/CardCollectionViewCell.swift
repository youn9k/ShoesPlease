//
//  CardCollectionViewCell.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2021/09/07.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var modelImage: UIImageView! // 제품 사진
    @IBOutlet weak var modelName: UILabel! // 모델명
    @IBOutlet weak var releaseSchedule: UILabel! // 발매 일정
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 15
    }
    
    

}
