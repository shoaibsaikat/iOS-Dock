//
//  DockCollectionView.swift
//  iOS-Dock
//
//  Created by Mina Shoaib Rahman on 11/9/24.
//

import UIKit

class DockCollectionView: UICollectionView {
    
    private var cellBackgrounds = [ "🌾", "🐇", "🌙", "🔥", "🌧", "🍎", "🍊", "🏔", "🏠"]

    override func draw(_ rect: CGRect) {
        let rect = CGRect(origin: CGPoint.zero, size: bounds.size)
        UIColor.systemBackground.setFill()
        UIRectFill(rect)
        let roundedDock = UIBezierPath(roundedRect: bounds, cornerRadius: 15)
        roundedDock.addClip()
        UIColor.brown.setFill()
        roundedDock.fill()
    }
}
