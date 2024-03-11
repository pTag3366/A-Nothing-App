//
//  IndexPath.swift
//  Nothing
//
//  Created by Jose Benitez on 3/7/24.
//

import Foundation

extension IndexPath {
    var commaSeparatedStringRepresentation: String {
        return "," + section.description + "," + row.description
    }
}

