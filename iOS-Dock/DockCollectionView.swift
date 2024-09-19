//
//  DockCollectionView.swift
//  iOS-Dock
//
//  Created by Mina Shoaib Rahman on 11/9/24.
//

import UIKit

class DockCollectionView: UICollectionView {
    
    override func draw(_ rect: CGRect) {
        let rect = CGRect(origin: CGPoint.zero, size: bounds.size)
        UIColor.systemBackground.setFill()
        UIRectFill(rect)
        let roundedDock = UIBezierPath(roundedRect: bounds, cornerRadius: 15)
        roundedDock.addClip()
        UIColor.brown.setFill()
        roundedDock.fill()
        
//        contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
}
