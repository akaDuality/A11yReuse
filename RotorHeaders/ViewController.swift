//
//  ViewController.swift
//  RotorHeaders
//
//  Created by Mikhail Rubanov on 16.09.2023.
//

import UIKit

struct DatasourceOverlay {
    
    let numberOfSections = 50
    let numberOfRowsInSection = 20
    
    var elements: [UIAccessibilityElement]
    
    init(accessibilityContainer: UIView) {
        
        func frame(at path: IndexPath, numberOfRowsInSection: Int) -> CGRect {
            let height: CGFloat = 60.33
            let elementIndex = path.section * numberOfRowsInSection + path.row
            let interitemSpace: CGFloat = 10
            let y: CGFloat = (height + interitemSpace) * CGFloat(elementIndex)
            - CGFloat(path.section) * interitemSpace // No space between sections
            let origin = CGPoint(x: 0, y: y)
            let size = CGSize(width: accessibilityContainer.frame.width, height: height)
            let frame = CGRect(origin: origin, size: size)
            return frame
        }
        
        var elements = [UIAccessibilityElement]()
        
        for section in 0..<numberOfSections {
            for row in 0..<numberOfRowsInSection {
                let element = UIAccessibilityElement(accessibilityContainer: accessibilityContainer)
                if row == 0 {
                    element.accessibilityLabel = "Header \(section)"
                    element.accessibilityTraits = [.header]
                } else {
                    element.accessibilityLabel = "Section \(section), row \(row)"
                    element.accessibilityTraits = [.staticText]
                }
                
                let path = IndexPath(row: row, section: section)
                element.accessibilityFrameInContainerSpace = frame(at: path,
                                                                   numberOfRowsInSection: numberOfRowsInSection)
                
                elements.append(element)
            }
        }
        
        self.elements = elements
    }
}

class ViewController: UICollectionViewController {
    
    func collectionView() -> CollectionView {
        collectionView as! CollectionView
    }
    
    private var datasourceOverlay: DatasourceOverlay!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datasourceOverlay = DatasourceOverlay(accessibilityContainer: collectionView!)
        collectionView().elements = datasourceOverlay.elements
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        datasourceOverlay.numberOfSections
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        datasourceOverlay.numberOfRowsInSection
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        
        // TODO: Read value from datasource
        if indexPath.row == 0 {
            cell.text = "Header \(indexPath.section)"
        } else {
            cell.text = "Section \(indexPath.section), row \(indexPath.row)"
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
