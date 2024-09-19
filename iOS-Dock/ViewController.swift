//
//  ViewController.swift
//  iOS-Dock
//
//  Created by Mina Shoaib Rahman on 9/9/24.
//

import UIKit

class ViewController: UIViewController, UIDropInteractionDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var cellBackgrounds = [ "🌾", "🐇", "🌙", "🔥", "🌧", "🍎", "🍊", "🏔", "🏠"]
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var dockCV: UICollectionView! {
        didSet {
            dockCV.dataSource = self
            dockCV.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        view.addInteraction(UIDropInteraction(delegate: self))
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: UIImage.self, completion: { images in
            if let image = images.first as? UIImage {
                self.imageView.image = image
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellBackgrounds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Dock Cell", for: indexPath)
        cell.backgroundColor = indexPath.item % 2 == 0 ? .red : .green
        return cell
    }
}

