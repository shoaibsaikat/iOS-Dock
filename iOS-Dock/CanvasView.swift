//
//  CanvasView.swift
//  iOS-Dock
//
//  Created by Mina Shoaib Rahman on 28/9/24.
//

import UIKit

class CanvasView: UIView, UIDropInteractionDelegate {
    
    var backgroundImage: UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }
    
    func setup() {
        addInteraction(UIDropInteraction(delegate: self))
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self) || session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    @objc func tapGestureRecog(recognizer: UITapGestureRecognizer) {
        print("tapped")
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: UIImage.self, completion: { images in
            if let image = images.first as? UIImage {
                self.backgroundImage = image
            }
        })
        
        session.loadObjects(ofClass: NSAttributedString.self, completion: { texts in
            if let text = (texts as? [NSAttributedString] ?? []).first {
                let label = UILabel()
                label.attributedText = text
                label.center = session.location(in: self)
                label.backgroundColor = .clear
                label.sizeToFit()
                label.isUserInteractionEnabled = true
                self.addSubview(label)
//                CanvasItemPinchRecognizer().bindLabelWithRecognizer(label: label)
//                label.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(CanvasItemPinchRecognizer.pinchRecognizer(recognizer:))))
                label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapGestureRecog(recognizer:))))
            }
        })
    }
}
