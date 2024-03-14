//
//  Note.swift
//  Nothing
//
//  Created by Jose Benitez on 3/13/24.
//

import Foundation
import CoreData

@objc (Note)
public class Note: NSManagedObject {
    
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }
    
    struct Date {
        static let dateCreated = "dateCreated"
    }
    
//    @NSManaged public var dateModified: Date?
//    @NSManaged public var dateCreated: Date?
    @NSManaged public var textData: Data?
    @NSManaged public var url: URL?
    @NSManaged public var uuid: UUID?
}
