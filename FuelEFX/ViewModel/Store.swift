//
//  Store.swift
//  FuelEFX
//
//  Created by Cube on 9/3/23.
//

import Foundation

protocol Store: ObservableObject {
    associatedtype RecordType: Codable, Identifiable
    
    var records: [RecordType] { get set }
    var filename: String { get }
    
    
    func addRecord(_ entry: RecordType)
    func editRecord(_ entry: RecordType)
    func deleteRecord (_ entry: RecordType)
    func saveRecords()
    func loadRecords()
    func getDocumentsDirectory() -> URL
}
