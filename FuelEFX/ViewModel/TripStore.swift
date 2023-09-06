//
//  TripStore.swift
//  FuelEFX
//
//  Created by Cube on 9/3/23.
//

import Foundation

// Class TripStore that extends the Store protocol and conforms to the ObservableObject protocol to be usable by SwiftUI views.
class TripStore: ObservableObject, Store {
    typealias RecordType = Trip //Define the type of record
    
    @Published var records: [Trip] // All fuel records
    @Published var tripError: StoreError? // Error state.
    
    let filename = "TripRecords.json" // Filename for saving records.
    
    // Initializer (Contructor) for the TripStore class
    init() {
        records = []
        // Try to load exisiting records.
        do {
            try loadRecords()
        } catch let error as StoreError {
            tripError = error
        } catch {
            print("Unexpected error: \(error).")
            tripError = StoreError.loadingFailed
        }
    }
    
    // Add a trip record
    func addRecord(_ entry: Trip) {
        records.append(entry)
        // Try to save the added record
        do{
            try saveRecords()
        } catch let error as StoreError{
            tripError = error
        } catch {
            print("Unexpected error: \(error)")
            tripError = StoreError.encodeFailed
        }
    }
    
    // Edit an exisiting trip record
    func editRecord(_ entry: Trip) {
        // Find record by ID
        if let index = records.firstIndex(where: { $0.id == entry.id }) {
            records[index] = entry
            // Try to save the edited record
            do{
                try saveRecords()
            } catch let error as StoreError{
                tripError = error
            } catch {
                print("Unexpected error: \(error)")
                tripError = StoreError.encodeFailed
            }
        }
    }
    
    // Delete a trip record
    func deleteRecord(_ entry: Trip) {
        // Remove record by ID
        records.removeAll { $0.id == entry.id }
        // Try to save after deletion
        do{
            try saveRecords()
        } catch let error as StoreError{
            tripError = error
        } catch {
            print("Unexpected error: \(error)")
            tripError = StoreError.encodeFailed
        }
    }
    
    // Save records to file
    func saveRecords() throws {
        do {
            // Encode records
            guard let data = try Bundle.main.encode(object: records) else {
                print("Failed to encode records to data.")
                return
            }
            // URL for saving.
            let url = getDocumentsDirectory().appendingPathComponent(filename)
            // Try to write data
            do {
                try data.write(to: url, options: .atomicWrite)
                print("Successfully saved data to \(url)")
            } catch {
                print("Error saving trip entries to \(url): \(error)")
            }
        } catch StoreError.encodeFailed {
            self.tripError = StoreError.encodeFailed
        }
    }
    
    // Load records from file
    func loadRecords() throws {
        do{
            let decodedData: [Trip] = try Bundle.main.decode(filename: filename, as: [Trip].self)
            records = decodedData
        } catch StoreError.loadingFailed {
            self.tripError = StoreError.loadingFailed
        }catch StoreError.nofilefound {
            self.tripError = StoreError.nofilefound
        }catch StoreError.decodefailed{
            self.tripError = StoreError.decodefailed
        }
    }
    
    // Get the URL of the documents directory
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    

}
