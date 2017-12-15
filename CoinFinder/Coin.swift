//
//  Coin.swift
//  CoinFinder
//
//  Created by Siwa Sardjoemissier on 11/12/2017.
//  Copyright © 2017 Siwa Sardjoemissier. All rights reserved.
//

import UIKit

struct Coin: Codable {
    var name: String?
    var dateCreated: String?
    var volume: Int?
    var commits: Int?
    
//    static func loadToDos() -> [ToDo]? {
//        guard let codedToDos = try? Data(contentsOf: ArchiveURL)
//            else {return nil}
//        let propertyListDecoder = PropertyListDecoder()
//        return try? propertyListDecoder.decode(Array<ToDo>.self,
//                                               from: codedToDos)
//    }
//
//    static func saveToDos(_ todos: [ToDo]) {
//        let propertyListEncoder = PropertyListEncoder()
//        let codedToDos = try? propertyListEncoder.encode(todos)
//        try? codedToDos?.write(to: ArchiveURL,
//                               options: .noFileProtection)
//    }
    func toAnyObject() -> Any {
        return [
            "name": name,
            "dateCreated": dateCreated,
            "volume": volume,
            "commits": commits
        ]
    }
    
    static let DocumentsDirectory =
        FileManager.default.urls(for: .documentDirectory,
                                 in: .userDomainMask).first!
    static let ArchiveURL =
        DocumentsDirectory.appendingPathComponent("coinfinder")
            .appendingPathExtension("plist")
    
    
}
