//
//  DockCollectionView.swift
//  iOS-Dock
//
//  Created by Mina Shoaib Rahman on 11/9/24.
//

import UIKit

class DockCollectionView: UICollectionView {
    
    private let dockCorner = 15.0
    private let insetPadding = 30.0
    
    override func draw(_ rect: CGRect) {
        let rect = CGRect(origin: CGPoint.zero, size: bounds.size)
        UIColor.systemBackground.setFill()
        UIRectFill(rect)
        let roundedDock = UIBezierPath(roundedRect: bounds, cornerRadius: dockCorner)
        roundedDock.addClip()
        UIColor.brown.withAlphaComponent(0.8).setFill()
        roundedDock.fill()
        
        contentInset = UIEdgeInsets(top: 0, left: insetPadding, bottom: 0, right: insetPadding)
    }
}
