//
//  ViewController.swift
//  A11yReuse
//
//  Created by Mikhail Rubanov on 16.09.2023.
//

import UIKit

class ViewController: UICollectionViewController {
    
    func collectionView() -> CollectionView {
        collectionView as! CollectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var elements = [UIAccessibilityElement]()
        
        let numberOfRows = 20
        
        for section in 0..<50 {
            for row in 0..<numberOfRows {
                let element = UIAccessibilityElement(accessibilityContainer: collectionView!)
                if row == 0 {
                    element.accessibilityLabel = "Header \(section)"
                    element.accessibilityTraits = [.header]
                } else {
                    element.accessibilityLabel = "Section \(section), row \(row)"
                    element.accessibilityTraits = [.staticText]
                }
                
                let height: CGFloat = 60.33
                let elementIndex = section * numberOfRows + row
                let interitemSpace: CGFloat = 10
                let y: CGFloat = (height + interitemSpace) * CGFloat(elementIndex)
                - CGFloat(section) * interitemSpace // No space between sections
                let origin = CGPoint(x: 0, y: y)
                let size = CGSize(width: view.frame.width, height: height)
                let frame = CGRect(origin: origin, size: size)
                element.accessibilityFrameInContainerSpace = frame
                
                elements.append(element)
            }
        }
        
        collectionView().elements = elements
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
        
//        print("Frame \(cell.frame) an \(indexPath)")
        return cell
    }
}

class CollectionView: UICollectionView {
    
    var elements = [UIAccessibilityElement]() {
        didSet {
            accessibilityElements = elements
        }
    }
    
    // Strange, but won't work without this code
    override var accessibilityElements: [Any]? {
        set {
            print("set accessibilityElements")
            super.accessibilityElements = newValue
        }
        get {
            print("get accessibilityElements")
            return super.accessibilityElements
        }
    }
    
    override func accessibilityElement(at index: Int) -> Any? {
        print("accessibilityElement(at: \(index))")
        return elements[index]
    }
    
    override func accessibilityElementCount() -> Int {
        print("accessibilityElementCount")
        return elements.count
    }
    
    override func index(ofAccessibilityElement element: Any) -> Int {
        let element = element as! UIAccessibilityElement
        let index = elements.firstIndex { elementInArray in
            elementInArray === element
        } ?? 0
        
        print("index(ofAccessibilityElement:) -> \(index)")
        return index
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
