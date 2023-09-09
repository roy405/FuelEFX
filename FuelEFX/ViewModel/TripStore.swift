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
    
    @Published var records: [Trip] = []// All fuel records
    @Published var tripError: StoreError? // Error state.
    
    var filename = "TripRecords.json" // Filename for saving records.
    
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
            let documentsURL = getDocumentsDirectory().appendingPathComponent(filename)
            if FileManager.default.fileExists(atPath: documentsURL.path) {
                do{
                    let decodedData: [Trip] = try Bundle.main.decode(url: documentsURL, as: [Trip].self)
                    records = decodedData
                } catch {
                    self.tripError = StoreError.decodefailed
                    throw StoreError.decodefailed
                }
            } else {
                guard let bundledURL = Bundle.main.url(forResource: filename, withExtension: nil) else {
                    self.tripError = StoreError.nofilefound
                    throw StoreError.nofilefound
                }
                do {
                    let decodedData: [Trip] = try Bundle.main.decode(url: bundledURL, as: [Trip].self)
                    records = decodedData
                } catch {
                    self.tripError = StoreError.decodefailed
                    throw StoreError.decodefailed
                }
                
            }
        } catch let error as StoreError {
            self.tripError = error
            throw error
        } catch {
            self.tripError = StoreError.loadingFailed
            throw StoreError.loadingFailed
        }
    }
    
    // Get the URL of the documents directory
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // Function to validate the input from user when creating a new trip record
    func isValidInput(startOdometer: String, endOdometer: String, startLocation: String, endLocation: String, purpose: String) -> (Bool, title: String, message: String) {
        if startOdometer.isEmpty || endOdometer.isEmpty || startLocation.isEmpty || endLocation.isEmpty || purpose.isEmpty {
            return (false, "Validation Error", "All fields are required. Please fill them out before saving.")
        }
        
        guard let _ = Double(startOdometer), let _ = Double(endOdometer) else {
            return (false, "Input Error", "Start and End Odometer readings must be valid numbers.")
        }
        
        return (true, "", "")
    }
    
    // Function to save trip entry when creating a new Trip Record
    func saveTripEntry(date: Date, startOdometer: String, endOdometer: String, startLocation: String, endLocation: String, purpose: String, notes: String) -> (Bool, title: String, message: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yy"
        
        guard let odometerStart = Double(startOdometer), let odometerEnd = Double(endOdometer) else {
            return (false, "Input Error", "Start and End Odometer readings must be valid numbers.")
        }
        
        let stringDate = dateFormatter.string(from: date)
        let newId = records.count + 1
        let tripRecord = Trip(id: newId,
                              tripDate: stringDate,
                              startOdometer: odometerStart,
                              endOdometer: odometerEnd,
                              startLocation: startLocation,
                              endLocation: endLocation,
                              purpose: purpose,
                              notes: notes)
        addRecord(tripRecord)
        
        return (true, "Success", "Trip entry has been saved successfully.")
    }
    
    // Function to validate the data from the TripDetailView edit
    func validatedEditFields(tripDate: String, startOdometer: String, endOdometer: String, startLocation: String, endLocation: String, purpose: String, notes: String) -> (isValid: Bool, alertTitle: String, alertMessage: String){
        
        guard !tripDate.isEmpty, !startLocation.isEmpty, !endLocation.isEmpty, !purpose.isEmpty else {
            return (false, "Missing Fields", "Please fill all the fields.")
        }
        
        guard Double(startOdometer) != nil, Double(endOdometer) != nil else {
            return (false, "Invalid Input", "Please ensure start and end odometer Reading fields contain valid numbers")
        }
        
        return(true, "", "")
    }
    
    // Function to create trip object with the new updated inputs and pass onto Store function
    func saveEditedTripChanges(trip: Trip, tripDate: String, startOdometer: String, endOdometer: String, startLocation: String, endLocation: String, purpose: String, notes: String) -> Bool {
        let editedTripRecord = Trip(
            id: trip.id,
            tripDate: tripDate,
            startOdometer: Double(startOdometer) ?? 0.0,
            endOdometer: Double(endOdometer) ?? 0.0,
            startLocation: startLocation,
            endLocation: endLocation,
            purpose: purpose,
            notes: notes
        )
        
        editRecord(editedTripRecord)
        return true
    }
    
}
