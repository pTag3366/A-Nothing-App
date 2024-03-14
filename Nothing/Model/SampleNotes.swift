//
//  SampleNotes.swift
//  Nothing
//
//  Created by Jose Benitez on 3/12/24.
//

import Foundation
import CoreData

struct SampleNotes {
    
    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }()
    
    static var dateComponents: DateComponents = {
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar(identifier: .gregorian)
        dateComponents.year = 2024
        return dateComponents
    }()
    
    static func randomText(length: Int) -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
    
    static func generateNewNote(with components: DateComponents, context: NSManagedObjectContext) {
        let note = Note(context: context)            /* @NSManaged public var dateModified: Date?
                                                        @NSManaged public var dateCreated: Date?
                                                        @NSManaged public var textData: Data?
                                                        @NSManaged public var url: URL?
                                                        @NSManaged public var uuid: UUID? */
        
        
//        let day = components.day
//        let date = components.date
        let uuid = UUID()
        let url = URL(string: note.uuid?.uuidString ?? "unknownURL")
        let textData = randomText(length: Int.random(in: 1...200)).utf8
        note.uuid = uuid
        note.dateCreated = dateComponents.calendar?.date(from: dateComponents)
//        note.dateModified = dateComponents.calendar?.date(from: dateComponents)
        note.url = url
        note.textData = Data(textData)
    }
    
    static func generateSampleDataIfNeeded(context: NSManagedObjectContext) {
        context.perform {
            guard let numberOfNotes = try? context.count(for: Note.fetchRequest()), numberOfNotes == 0 else {
                return
            }
            for day in stride(from: 1, through: 365, by: Int.random(in: 0...28)) {
                let month = (day/30)
                dateComponents.year = 2024
                dateComponents.month = month
                dateComponents.day = day
                dateComponents.hour = Int.random(in: 0...23)
                dateComponents.minute = Int.random(in: 0...59)
                dateComponents.second = Int.random(in: 0...59)
                for note in stride(from: 1, through: Int.random(in: 1...5), by: 1) {
//                    guard let date = dateComponents.date else { return }
//                    let dateString = dateFormatter.string(from: date)
                    generateNewNote(with: dateComponents, context: context)
                }
            }
            do {
                try context.save()
            } catch {
                print("error saving data: \(error)")
            }
        }
    }
}
