//
//  ViewController.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2021/09/07.
//

import UIKit

class MainViewController: UIViewController {
  
    @IBOutlet weak var cardCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cardCollectionView.delegate = self
        self.cardCollectionView.dataSource = self
        self.cardCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        self.setupFlowLayout()
        
    }


}



