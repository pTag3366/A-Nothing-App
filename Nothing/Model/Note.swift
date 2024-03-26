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
        static let lastModified = "lastModified"
    }
    
    @NSManaged public var dateCreated: Date?
    @NSManaged public var lastModified: Date?
    @NSManaged public var textData: Data?
    @NSManaged public var url: URL?
    @NSManaged public var uuid: UUID?
    
    public convenience init(context moc: NSManagedObjectContext, data: Data) {
        self.init(context: moc)
        let date = Date()
        let uuid = UUID()
        self.dateCreated = date
        self.lastModified = date
        self.uuid = uuid
        self.textData = data
        self.url = URL(string: uuid.uuidString)
    }
}
