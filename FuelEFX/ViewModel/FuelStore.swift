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
    let filename = "FuelRecords.json"
    
    init() {
        records = []
        loadRecords()
    }
    
    func addRecord(_ entry: Fuel) {
            records.append(entry)
            saveRecords()
    }
    
    func editRecord(_ entry: Fuel) {
        if let index = records.firstIndex(where: { $0.id == entry.id }) {
            records[index] = entry
            saveRecords()
        }
    }
        
    func deleteRecord(_ entry: Fuel) {
            records.removeAll { $0.id == entry.id }
            saveRecords()
    }
    
    func saveRecords() {
        do {
            let data = Bundle.main.encode(object: records)
            let url = getDocumentsDirectory().appendingPathComponent("FuelRecords.json")
            try data?.write(to: url)
        } catch {
            print("Error saving fuel entries: \(error)")
        }
    }
        
    func loadRecords() {
        let decodedData: [Fuel] = Bundle.main.decode(filename: filename, as: [Fuel].self)
        records = decodedData
    }
        
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
