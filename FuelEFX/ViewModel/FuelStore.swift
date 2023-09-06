//
//  FuelStore.swift
//  FuelEFX
//
//  Created by Cube on 9/3/23.
//

import Foundation

class FuelStore: ObservableObject, Store {
    typealias RecordType = Fuel
    
    @Published var records: [Fuel]
    @Published var fuelError: StoreError?
    
    let filename = "FuelRecords.json"
    
    init() {
        records = []
        do {
            try loadRecords()
        } catch let error as StoreError {
            fuelError = error
        } catch {
            print("Unexpected error: \(error).")
            fuelError = StoreError.loadingFailed
        }
    }
    
    func addRecord(_ entry: Fuel) {
        records.append(entry)
        do{
            try saveRecords()
        } catch let error as StoreError{
            fuelError = error
        } catch {
            print("Unexpected error: \(error)")
            fuelError = StoreError.encodeFailed
        }
    }
    
    func editRecord(_ entry: Fuel) {
        if let index = records.firstIndex(where: { $0.id == entry.id }) {
            records[index] = entry
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
        
    func deleteRecord(_ entry: Fuel) {
        records.removeAll { $0.id == entry.id }
        do{
            try saveRecords()
        } catch let error as StoreError{
            fuelError = error
        } catch {
            print("Unexpected error: \(error)")
            fuelError = StoreError.encodeFailed
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
                print("Error saving fuel entries to \(url): \(error)")
            }
        } catch StoreError.encodeFailed {
            self.fuelError = StoreError.encodeFailed
        }

    }
        
    func loadRecords() throws {
        do{
            let decodedData: [Fuel] = try Bundle.main.decode(filename: filename, as: [Fuel].self)
            records = decodedData
        } catch StoreError.loadingFailed {
            self.fuelError = StoreError.loadingFailed
        }catch StoreError.nofilefound {
            self.fuelError = StoreError.nofilefound
        }catch StoreError.decodefailed{
            self.fuelError = StoreError.decodefailed
        }
    }
        
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}


