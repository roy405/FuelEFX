//
//  Store.swift
//  FuelEFX
//
//  Created by Cube on 9/3/23.
//

import Foundation

// A protocol defining the basic operations for a data store.
// The `Store` protocol is observable and can be used with SwiftUI views that rely on the data it manages.
protocol Store: ObservableObject {
    // An associated type that dictates the type of records the store will handle.
    // This type must conform to both `Codable` and `Identifiable`.
    associatedtype RecordType: Codable, Identifiable
    
    var records: [RecordType] { get set } // A collection of records of `RecordType` that the store manages.
    var filename: String { get } // The filename where the records are persisted.
    
    /// Adds a new record to the store.
    func addRecord(_ entry: RecordType)
    /// Modifies an existing record in the store.
    func editRecord(_ entry: RecordType)
    /// Deletes a record from the store.
    func deleteRecord (_ entry: RecordType)
    /// Persists the current records to storage.
    func saveRecords() throws
    /// Loads the records from storage.
    func loadRecords() throws
    /// Provides the URL for the directory where documents are saved.
    func getDocumentsDirectory() -> URL
}
