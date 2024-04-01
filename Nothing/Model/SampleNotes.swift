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
    
    static func formatHeaderTitle(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.setLocalizedDateFormatFromTemplate("EEEE, MMMM d, yyyy")
        return formatter.string(from: date).localizedCapitalized
    }
    
    static func generateNewRandomNote(with components: DateComponents, context: NSManagedObjectContext) {
        let note = Note(context: context)
        
        let uuid = UUID()
        let url = URL(string: note.uuid?.uuidString ?? "unknownURL")
        let textData = randomText(length: Int.random(in: 1...200)).utf8
        note.uuid = uuid
        if let date = dateComponents.calendar?.date(from: dateComponents) {
            note.dateCreated = date
            note.lastModified = date
        }
        note.url = url
        note.textData = Data(textData)
    }
    
    static func generateNewEmptyNote(context: NSManagedObjectContext) {
        let note = Note(context: context)
        
        let uuid = UUID()
        note.uuid = uuid
        let url = URL(string: note.uuid?.uuidString ?? "unknownURL")
        note.url = url
        let date = Date()
        note.dateCreated = date
        note.lastModified = date
    }
    
    static func generateEmptyNoteIfNeeded(context: NSManagedObjectContext) {
        context.perform {
            if let numberOfNotes = try? context.count(for: Note.fetchRequest()), numberOfNotes == 0 {
                generateNewEmptyNote(context: context)
            }
            do {
                try context.save()
            } catch {
                print("error saving data: \(error)")
            }
        }
    }
    
    static func generateSampleDataIfNeeded(context: NSManagedObjectContext) {
        context.perform {
            guard let numberOfNotes = try? context.count(for: Note.fetchRequest()), numberOfNotes == 0 else {
                return
            }
            for day in stride(from: 1, through: 365, by: 7) {
                dateComponents.day = day
                for _ in 0...Int.random(in: 0...10) {
                    generateNewRandomNote(with: dateComponents, context: context)
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
