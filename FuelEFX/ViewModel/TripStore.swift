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
    var filename = "TripRecords.json"
    
    init(){
        records = []
        loadRecords()
    }
    
    func addRecord(_ entry: Trip) {
        records.append(entry)
        saveRecords()
    }
    
    func editRecord(_ entry: Trip) {
        if let index = records.firstIndex(where: { $0.id == entry.id }) {
            records[index] = entry
            saveRecords()
        }
    }
    
    func deleteRecord(_ entry: Trip) {
        records.removeAll { $0.id == entry.id }
        saveRecords()
    }
    
    func saveRecords() {
        do {
            let data = Bundle.main.encode(object: records)
            let url = getDocumentsDirectory().appendingPathComponent("TripRecords.json")
            try data?.write(to: url)
        } catch {
            print("Error saving trip entries: \(error)")
        }
    }
    
    func loadRecords() {
        let decodedData: [Trip] = Bundle.main.decode(filename: filename, as: [Trip].self)
        records = decodedData
    }
    
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    

}
