//
//  NothingCollectionViewCell+Extension.swift
//  Nothing
//
//  Created by Jose Benitez on 3/7/24.
//

import Foundation

extension NothingCollectionViewCell {
    var stackViewFrame: CGRect {
        return stackView.frame
    }
    
    var indexPathFromAccessibilityLabel: IndexPath {
        guard let components = accessibilityLabel?.components(separatedBy: ","),
              components.count == 3,
              let row = Int(components[2]),
              let section = Int(components[1]) else { return IndexPath() }
        
        let index = IndexPath(row: row, section: section)
        return index
    }
}
