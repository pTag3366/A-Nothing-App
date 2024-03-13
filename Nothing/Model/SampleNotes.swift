//
//  SampleNotes.swift
//  Nothing
//
//  Created by Jose Benitez on 3/12/24.
//

import Foundation
import CoreData

struct SampleNotes {
    
    var dateComponents: DateComponents = {
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar(identifier: .gregorian)
        dateComponents.year = 2024
        return dateComponents
    }()
    
    func randomText(length: Int) -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
    
    func generateNewNote(with components: DateComponents, context: NSManagedObjectContext) {
        
    }
}
