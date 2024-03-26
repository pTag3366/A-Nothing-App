//
//  Notes.swift
//  Nothing
//
//  Created by Jose Benitez on 3/25/24.
//

import Foundation

enum NoteError: Error {
    case incompleteData
}

struct NotesList: Decodable {
    private(set) var notes = [Notes]()
    
    init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        while !container.isAtEnd {
            if let note = try? container.decode(Notes.self) {
                notes.append(note)
            }
        }
    }
}

struct Notes: Decodable {

    private enum CodingKeys: String, CodingKey {
        case dateCreated
        case dateString
        case lastModified
        case textData
        case url
        case uuid
    }
    
    let dateCreated: Date
    var dateString: String
    let lastModified: Date
    var textData: Data
    var url: URL
    let uuid: UUID
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateCreated = try? container.decode(Date.self, forKey: .dateCreated)
        let dateString = try? container.decode(String.self, forKey: .dateString)
        let lastModified = try? container.decode(Date.self, forKey: .lastModified)
        let textData = try? container.decode(Data.self, forKey: .textData)
        let url = try? container.decode(URL.self, forKey: .url)
        let uuid = try? container.decode(UUID.self, forKey: .uuid)
        guard let dateCreated = dateCreated, let dateString = dateString, let lastModified = lastModified, let textData = textData, let url = url, let uuid = uuid else { throw NoteError.incompleteData }
        self.dateCreated = dateCreated
        self.dateString = dateString
        self.lastModified = lastModified
        self.textData = textData
        self.url = url
        self.uuid = uuid
    }
    
    var dictionaryValue: [String: Any] {
        [
            "dateCreated": dateCreated,
            "dateString": dateString,
            "lastModified": lastModified,
            "textData": textData,
            "url": url,
            "uuid": uuid
        ]
    }
}
