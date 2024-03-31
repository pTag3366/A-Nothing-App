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
    
    class func newBackgroundTaskContext(_ store: NSPersistentContainer) -> NSManagedObjectContext {
        let taskContext = store.newBackgroundContext()
//        taskContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy // ??
//        taskContext.undoManager = UndoManager()
        return taskContext
    }
    
    class func insertNote(with note: Note, task: NSManagedObjectContext) {
        task.perform {
            do {
                let noteDict = try Notes(from: note)
                let _ = NSBatchInsertRequest(entity: Note.entity(), dictionaryHandler: { dict in
                    dict.addEntries(from: noteDict.dictionaryValue)
                    return true
                })
                try task.save()
            } catch {
                
            }
        }
    }
    
    class func removeNoteFromViewContext(store: NSPersistentContainer, controller: NSFetchedResultsController<Note>, at indexPath: IndexPath) {
        let note = controller.object(at: indexPath)
        let viewContext = store.viewContext
        viewContext.perform {
            let objToDelete = viewContext.object(with: note.objectID)
            viewContext.delete(objToDelete)
        }
    }
    
    class func removeNoteFromPersistentStore(_ note: Note, task: NSManagedObjectContext) {
        guard let _ = note.textData else { return }
        task.perform {
            let deleteRequest = NSBatchDeleteRequest(objectIDs: [note.objectID])
            guard let fetchResult = try? task.execute(deleteRequest),
            let deleteResult = fetchResult as? NSBatchDeleteResult,
            let success = deleteResult.result as? Bool, success
            else { return }
        }
    }
    
    class func updateNote(note: Note, data: Data, task: NSManagedObjectContext) {
        task.perform {
            do {
                let batchUpdate = updateRequest(with: note, data: data)
                assert(batchUpdate.predicate != nil && batchUpdate.propertiesToUpdate != nil)
                
                guard let fetchResult = try? task.execute(batchUpdate),
                      let updateResult = fetchResult as? NSBatchUpdateResult,
                      let success = updateResult.result as? Bool, success
                else { return }
                try task.save()
            }
            catch {
                
            }
        }
    }
    
    private class func updateRequest(with note: Note, data: Data) -> NSBatchUpdateRequest {
        guard let uuid = note.uuid?.uuidString else { return NSBatchUpdateRequest() }
        let batchUpdate = NSBatchUpdateRequest(entity: Note.entity())
        let newDict : [AnyHashable: Any] = [AnyHashable: Any]()
        let predicate = NSPredicate(format: "uuid == %@", uuid)
        batchUpdate.predicate = predicate
        batchUpdate.propertiesToUpdate = newDict
        let dateModified = Date()
        batchUpdate.propertiesToUpdate?.updateValue(dateModified, forKey: "lastModified")
        batchUpdate.propertiesToUpdate?.updateValue(data, forKey: "textData")
        note.textData = data
        note.lastModified = dateModified
        return batchUpdate
    }
}
