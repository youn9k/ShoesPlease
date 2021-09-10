//
//  MainViewController+.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2021/09/08.
//

import UIKit

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12 // test Number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = cardCollectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as? CardCollectionViewCell else { return UICollectionViewCell() }
        cell.modelImage.image = UIImage(named: String((indexPath.row + 1)%7)) // test Image
        return cell
    }
    
    func setupFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 30
        
        let halfWidth = UIScreen.main.bounds.width / 2
        let halfHeight = UIScreen.main.bounds.height / 2
        flowLayout.itemSize = CGSize(width: halfWidth * 0.9 , height: halfHeight * 0.8)
        self.cardCollectionView.collectionViewLayout = flowLayout
    }
    
    
}
