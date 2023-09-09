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
    
    var filename = "FuelRecords.json" // Filename for saving records.
    
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
                do{
                    let decodedData: [Fuel] = try Bundle.main.decode(url: documentsURL, as: [Fuel].self)
                    records = decodedData
                } catch {
                    self.fuelError = StoreError.decodefailed
                    throw StoreError.decodefailed
                }
            } else {
                guard let bundledURL = Bundle.main.url(forResource: filename, withExtension: nil) else {
                    self.fuelError = StoreError.nofilefound
                    throw StoreError.nofilefound
                }
                do{
                    let decodedData: [Fuel] = try Bundle.main.decode(url: bundledURL, as: [Fuel].self)
                    records = decodedData
                } catch {
                    self.fuelError = StoreError.decodefailed
                    throw StoreError.decodefailed
                }
            }
        } catch let error as StoreError {
            self.fuelError = error
            throw error
        } catch {
            self.fuelError = StoreError.loadingFailed
            throw StoreError.loadingFailed
        }
    }
    
    // Get the URL of the documents directory.
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // Function to validate the input from user when creating a new fuel record
    func isValidInput(odometerReading: String, fuelAmount: String, fuelCost: String, fuelType: String, location: String) -> (Bool, title: String, message: String) {
        
        if odometerReading.isEmpty || fuelAmount.isEmpty || fuelCost.isEmpty || fuelType.isEmpty || location.isEmpty {
            return (false, "Validation Error", "All fields are required. Please fill them out before saving.")
        }
        
        guard let _ = Double(odometerReading), let _ = Double(fuelAmount), let _ = Double(fuelCost) else {
            return (false, "Input Error", "Odometer reading, fuel amount, and fuel cost must be valid numbers.")
        }
        
        return (true, "Success", "Input is valid.")
    }
    
    // Function to save fuel entry when creating a new Fuel Record
    func saveFuelEntry(date: Date, odometerReading: String, fuelAmount: String, fuelCost: String, fuelType: String, location: String, notes: String) -> (Bool, title: String, message: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yy"
        guard let odometer = Double(odometerReading),
              let amount = Double(fuelAmount),
              let cost = Double(fuelCost) else {
            return (false, "Input Error", "Start and End Odometer readings must be valid numbers.")
        }
        
        let stringDate = dateFormatter.string(from: date)
        let newId = records.count + 1
        
        let fuelRecord = Fuel(id: newId,
                              refillDate: stringDate,
                              odometerReading: odometer,
                              fuelAmount: amount,
                              fuelCost: cost,
                              fuelType: fuelType,
                              refillLocation: location,
                              notes: notes)
        
        addRecord(fuelRecord)
        
        return (true, "Success", "Fuel entry has been saved successfully.")
    }
    
    // Function to validate the data from the FuelDetailView edit process
    func validateEditFields(refillDate: String, odometerReading: String, fuelAmount: String, fuelCost: String, fuelType: String, refillLocation: String) -> (isValid: Bool, alertTitle: String, alertMessage: String) {
        
        guard !refillDate.isEmpty, !fuelType.isEmpty, !refillLocation.isEmpty else {
            return (false, "Missing Fields", "Please fill all the fields.")
        }
        
        guard Double(odometerReading) != nil, Double(fuelAmount) != nil, Double(fuelCost) != nil else {
            return (false, "Invalid Input", "Please ensure Odometer Reading, Fuel Amount and Fuel Cost fields contain valid numbers.")
        }
        
        return (true, "", "")
    }
    
    // Function to create fuel object with the new updated inputs and pass onto Store function
    func saveEditedFuelChanges(fuel: Fuel, refillDate: String, odometerReading: String, fuelAmount: String, fuelCost: String, fuelType: String, refillLocation: String, notes: String) -> Bool {
        let editedFuelRecord = Fuel(
            id: fuel.id,
            refillDate: refillDate,
            odometerReading: Double(odometerReading) ?? 0.0,
            fuelAmount: Double(fuelAmount) ?? 0.0,
            fuelCost: Double(fuelCost) ?? 0.0,
            fuelType: fuelType,
            refillLocation: refillLocation,
            notes: notes
        )
        
        editRecord(editedFuelRecord)
        return true
    }
}


