//
//  CanvasView.swift
//  iOS-Dock
//
//  Created by Mina Shoaib Rahman on 28/9/24.
//

import UIKit

class CanvasView: UIView, UIDropInteractionDelegate {
    
    var focusedView: UIView?
    
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
        addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(self.pinchRecognizer(recognizer:))))
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self) || session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    @objc func pinchRecognizer(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            recognizer.scale = 1.0
        case .began, .changed:
            if let label = focusedView as? UILabel {
                label.transform = label.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
                recognizer.scale = 1.0
            }
        default: break
        }
    }
    
    @objc func tapGestureRecog(recognizer: UITapGestureRecognizer) {
        focusedView = recognizer.view
    }
    
    @objc func longPressGestureRecog(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
//        case .began:
//            print("long pressed")
        case .changed, .ended:
            recognizer.view?.center = recognizer.location(in: recognizer.view?.superview)
        default:
            break
        }
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
                label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapGestureRecog(recognizer:))))
                label.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGestureRecog(recognizer:))))
                self.addSubview(label)
            }
        })
    }
}
