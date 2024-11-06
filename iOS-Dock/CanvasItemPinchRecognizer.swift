//
//  CanvasItemPinchRecognizer.swift
//  iOS-Dock
//
//  Created by Mina Shoaib Rahman on 30/9/24.
//

import UIKit

class CanvasItemPinchRecognizer: UIPinchGestureRecognizer {
    
    var label: UILabel = UILabel()
    
    func bindLabelWithRecognizer(label: UILabel) {
        self.label = label
    }
    
    @objc func pinchRecognizer(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            label.font = label.font.withSize(recognizer.scale * label.font.pointSize)
            recognizer.scale = 1.0
            print("tapped")
        default: break
        }
    }
}
