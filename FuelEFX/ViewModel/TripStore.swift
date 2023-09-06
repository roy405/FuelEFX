//
//  TripStore.swift
//  FuelEFX
//
//  Created by Cube on 9/3/23.
//

import Foundation

class TripStore: ObservableObject, Store {
    typealias RecordType = Trip
    
    @Published var records: [Trip]
    @Published var tripError: StoreError?
    
    let filename = "TripRecords.json"
    
    init() {
        records = []
        do {
            try loadRecords()
        } catch let error as StoreError {
            tripError = error
        } catch {
            print("Unexpected error: \(error).")
            tripError = StoreError.loadingFailed
        }
    }
    
    func addRecord(_ entry: Trip) {
        records.append(entry)
        do{
            try saveRecords()
        } catch let error as StoreError{
            tripError = error
        } catch {
            print("Unexpected error: \(error)")
            tripError = StoreError.encodeFailed
        }
    }
    
    func editRecord(_ entry: Trip) {
        if let index = records.firstIndex(where: { $0.id == entry.id }) {
            records[index] = entry
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
    
    func deleteRecord(_ entry: Trip) {
        records.removeAll { $0.id == entry.id }
        do{
            try saveRecords()
        } catch let error as StoreError{
            tripError = error
        } catch {
            print("Unexpected error: \(error)")
            tripError = StoreError.encodeFailed
        }
    }
    
    func saveRecords() throws {
        do {
            guard let data = try Bundle.main.encode(object: records) else {
                print("Failed to encode records to data.")
                return
            }
            
            let url = getDocumentsDirectory().appendingPathComponent(filename)
            
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
    
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    

}
