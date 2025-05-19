//
//  CustomCollectionViewLayout.swift
//  Sports App
//
//  Created by Kerolos on 15/05/2025.
//

import UIKit

class CustomCollectionViewLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    private func setupLayout() {
        minimumInteritemSpacing = 10
        minimumLineSpacing = 10
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        // Set scroll direction based on section
        for section in 0..<collectionView.numberOfSections {
            if let firstItem = layoutAttributesForItem(at: IndexPath(item: 0, section: section)) {
                let scrollDirection: UICollectionView.ScrollDirection = section == 1 ? .vertical : .horizontal
                
                switch scrollDirection {
                case .horizontal:
                    firstItem.frame.origin.x = sectionInset.left
                case .vertical:
                    firstItem.frame.origin.y = sectionInset.top
                @unknown default:
                    break
                }
            }
        }
    }
}
