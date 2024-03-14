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
    
    struct Dates {
        static let dateCreated = "dateCreated"
        static let dateModified = "dateModified"
    }
    
//    @NSManaged private var persistedDateCreated: Date?
//    @NSManaged private var persistedDateModified: Date?
    
    @NSManaged public var dateCreated: Date?
    @NSManaged public var dateModified: Date?
    @NSManaged public var textData: Data?
    @NSManaged public var url: URL?
    @NSManaged public var uuid: UUID?
    
//    @objc public var dateCreated: Date? {
//        get {
//            willAccessValue(forKey: Dates.dateCreated)
//            defer { didAccessValue(forKey: Dates.dateCreated) }
//            return persistedDateCreated
//        }
//        set {
//            willChangeValue(forKey: Dates.dateCreated)
//            defer { didChangeValue(forKey: Dates.dateCreated) }
//            persistedDateCreated = newValue
//        }
//    }
}
