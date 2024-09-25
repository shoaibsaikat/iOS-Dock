//
//  ViewController.swift
//  iOS-Dock
//
//  Created by Mina Shoaib Rahman on 9/9/24.
//

import UIKit

class ViewController: UIViewController, UIDropInteractionDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    private let dockCellWidth: CGFloat = 165.0
    private let dockCellHeightPadding: CGFloat = 40.0

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var dockCV: UICollectionView! {
        didSet {
            dockCV.dataSource = self
            dockCV.delegate = self
            dockCV.dragDelegate = self
            dockCV.dropDelegate = self
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
        return DockCellModel.CellBackgrounds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Dock Cell", for: indexPath) as? DockCollectionViewCell
        cell?.label.text = DockCellModel.CellBackgrounds[indexPath.item]
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: dockCellWidth, height: collectionView.bounds.height - dockCellHeightPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if let uiItem = collectionView.cellForItem(at: indexPath) as? DockCollectionViewCell, let text = uiItem.label.text {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: NSAttributedString(string: text)))
            dragItem.localObject = NSAttributedString(string: text)
            return [dragItem]
        } else {
            return []
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: (session.localDragSession?.localContext as? UICollectionView) == collectionView ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(row: 0, section: 0)
        for item in coordinator.items {
            if let source = item.sourceIndexPath?.item {
                // collectionView
                if let text = (item.dragItem.localObject as? NSAttributedString)?.string {
                    collectionView.performBatchUpdates({
                        DockCellModel.CellBackgrounds.remove(at: source)
                        DockCellModel.CellBackgrounds.insert(text, at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [item.sourceIndexPath!])
                        collectionView.insertItems(at: [destinationIndexPath])
                    }, completion: { _ in
                        // works without drop, but needed for the animation
                        coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                    })
                }
            } else if let _ = item.dragItem.localObject as? NSAttributedString {
                // local
            } else {
                // external
                let placeholderContext = coordinator.drop(item.dragItem, to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "Dock Placeholder Cell"))
                item.dragItem.itemProvider.loadObject(ofClass: NSAttributedString.self, completionHandler: { (provider, _) in
                    DispatchQueue.main.async {
                        if let attributedString = provider as? NSAttributedString {
                            placeholderContext.commitInsertion(dataSourceUpdates: { indexPath in
                                // just instring into the model will work because the cell will be drawn using dequeueReusableCell
                                DockCellModel.CellBackgrounds.insert(attributedString.string, at: destinationIndexPath.item)
                            })
                        }
                    }
                })
            }
        }
    }
}
