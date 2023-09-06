//
//  FuelStore.swift
//  FuelEFX
//
//  Created by Cube on 9/3/23.
//

import Foundation

// Class FuelStore that extends the Store protocol and conforms to the ObservableObject protocol to be usable by SwiftUI views.
class FuelStore: ObservableObject, Store {
    typealias RecordType = Fuel //Define the type of record
    
    @Published var records: [Fuel] // All fuel records
    @Published var fuelError: StoreError? // Error state.
    
    let filename = "FuelRecords.json" // Filename for saving records.
    
    // Initializer (Contructor) for the FuelStore class.
    init() {
        records = []
        // Try to load existing records.
        do {
            try loadRecords()
        } catch let error as StoreError {
            fuelError = error
        } catch {
            print("Unexpected error: \(error).")
            fuelError = StoreError.loadingFailed
        }
    }
    
    // Add a fuel record.
    func addRecord(_ entry: Fuel) {
        records.append(entry)
        // Try to save the added record.
        do{
            try saveRecords()
        } catch let error as StoreError{
            fuelError = error
        } catch {
            print("Unexpected error: \(error)")
            fuelError = StoreError.encodeFailed
        }
    }
    
    // Edit an existing fuel record.
    func editRecord(_ entry: Fuel) {
        // Find record by ID.
        if let index = records.firstIndex(where: { $0.id == entry.id }) {
            records[index] = entry
            // Try to save the edited record.
            do{
                try saveRecords()
            } catch let error as StoreError{
                fuelError = error
            } catch {
                print("Unexpected error: \(error)")
                fuelError = StoreError.encodeFailed
            }
        }
    }
    
    // Delete a fuel record.
    func deleteRecord(_ entry: Fuel) {
        // Remove record by ID.
        records.removeAll { $0.id == entry.id }
        // Try to save after deletion.
        do{
            try saveRecords()
        } catch let error as StoreError{
            fuelError = error
        } catch {
            print("Unexpected error: \(error)")
            fuelError = StoreError.encodeFailed
        }
    }
    
    // Save records to file.
    func saveRecords() throws {
        do {
            // Encode records.
            guard let data = try Bundle.main.encode(object: records) else {
                print("Failed to encode records to data.")
                return
            }
            // URL for saving.
            let url = getDocumentsDirectory().appendingPathComponent(filename)
            // Try to write data.
            do {
                try data.write(to: url, options: .atomicWrite)
                print("Successfully saved data to \(url)")
            } catch {
                print("Error saving fuel entries to \(url): \(error)")
            }
        } catch StoreError.encodeFailed {
            self.fuelError = StoreError.encodeFailed
        }

    }
    
    // Load records from file.
    func loadRecords() throws {
        do{
            let documentsURL = getDocumentsDirectory().appendingPathComponent(filename)
            if FileManager.default.fileExists(atPath: documentsURL.path) {
                let decodedData: [Fuel] = try Bundle.main.decode(url: documentsURL, as: [Fuel].self)
                records = decodedData
            } else {
                guard let bundledURL = Bundle.main.url(forResource: filename, withExtension: nil) else {
                    throw StoreError.nofilefound
                }
                let decodedData: [Fuel] = try Bundle.main.decode(url: bundledURL, as: [Fuel].self)
                records = decodedData
            }
        } catch StoreError.loadingFailed {
            self.fuelError = StoreError.loadingFailed
        }catch StoreError.decodefailed{
            self.fuelError = StoreError.decodefailed
        }
    }
    
    // Get the URL of the documents directory.
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}


