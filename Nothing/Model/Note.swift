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
        static let dateString = "dateString"
        static let lastModified = "lastModified"
    }
    
    @NSManaged public var primitiveDateCreated: Date?
    @NSManaged public var primitiveDateString: String?
    
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
    
    @objc public var dateCreated: Date? {
        get {
            willAccessValue(forKey: Dates.dateCreated)
            defer { didAccessValue(forKey: Dates.dateCreated) }
            return primitiveDateCreated
        }
        set {
            willChangeValue(forKey: Dates.dateCreated)
            defer { didChangeValue(forKey: Dates.dateCreated) }
            primitiveDateCreated = newValue
            primitiveDateString = nil
        }
    }
    
    @objc public var dateString: String? {
        willAccessValue(forKey: Dates.dateString)
        defer { didAccessValue(forKey: Dates.dateString) }
        
        guard primitiveDateString == nil, let date = primitiveDateCreated else {
            return primitiveDateString
        }
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day, .weekday], from: date)
        guard let date = calendar.date(from: components) else { return primitiveDateString }
        primitiveDateString = SampleNotes.formatHeaderTitle(date)
        
        return primitiveDateString
    }
    
    func update(from notes: Notes) throws {
        let dictionary = notes.dictionaryValue
        guard let newDateCreated = dictionary["dateCreated"] as? Date,
              let newLastModified = dictionary["lastModified"] as? Date,
              let newUuid = dictionary["uuid"] as? UUID,
              let newUrl = dictionary["url"] as? URL,
              let newTextData = dictionary["textData"] as? Data
        else {
            throw NoteError.incompleteData(description: "\(#function)")
        }
        dateCreated = newDateCreated
        lastModified = newLastModified
        uuid = newUuid //???
        url = newUrl   //???
        textData = newTextData
    }
}
