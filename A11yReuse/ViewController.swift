//
//  ViewController.swift
//  A11yReuse
//
//  Created by Mikhail Rubanov on 16.09.2023.
//

import UIKit

class ViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        50
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        
        if indexPath.row == 0 {
            cell.text = "Header \(indexPath.section)"
            cell.accessibilityTraits = [.header]
        } else {
            cell.text = "Section \(indexPath.section), row \(indexPath.row)"
            cell.accessibilityTraits = [.staticText]
        }
        
        return cell
    }
}

class Cell: UICollectionViewCell {
    @IBOutlet private var titleLabel: UILabel!
    
    var text: String = "" {
        didSet {
            titleLabel.text = text
            accessibilityLabel = text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        isAccessibilityElement = true
    }
}
