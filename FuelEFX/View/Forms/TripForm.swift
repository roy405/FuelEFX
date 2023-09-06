//
//  TripForm.swift
//  FuelEFX
//
//  Created by Cube on 9/3/23.
//

import SwiftUI

// SwiftUI view representing a form to input trip details.
struct TripForm: View {
    @ObservedObject var viewModel: TripStore // ViewModel to manage trip records.
    
    // State properties to hold user input.
    @State private var date = Date()
    @State private var startOdometer = ""
    @State private var endOdometer = ""
    @State private var startLocation = ""
    @State private var endLocation = ""
    @State private var purpose = ""
    @State private var notes = ""
    
    // State properties for displaying alerts.
    @State private var showAlert = false
    @State private var alertTitle = "Error"
    @State private var alertMessage = "An error occured"
    
    var body: some View {
        Form {
            Section(header: Text("Fuel Entry Details")) {
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Start Odometer Reading", text: $startOdometer)
                    .keyboardType(.decimalPad)
                TextField("End Odometer Reading", text: $endOdometer)
                    .keyboardType(.decimalPad)
                TextField("Start Location", text: $startLocation)
                TextField("End Location", text: $endLocation)
                TextField("Purpose", text: $purpose)
            }
            
            Section(header: Text("Notes")) {
                TextEditor(text: $notes)
                    .frame(height: 100)
            }
            // Button to save trip details after validation.
            Button("Save") {
                if isValidInput(){
                    saveTripEntry()
                }
            }
        }
        .navigationTitle("Add Fuel Entry")
        // Configuring the alert.
        .alert(isPresented: $showAlert){
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
      }
    
    // Function to validate user input before saving.
    private func isValidInput() -> Bool {
        if startOdometer.isEmpty || endOdometer.isEmpty || startLocation.isEmpty || endLocation.isEmpty || purpose.isEmpty {
                    alertTitle = "Validation Error"
                    alertMessage = "All fields are required. Please fill them out before saving."
                    showAlert = true
                    return false
                }
                
                guard let _ = Double(startOdometer), let _ = Double(endOdometer) else {
                    alertTitle = "Input Error"
                    alertMessage = "Start and End Odometer readings must be valid numbers."
                    showAlert = true
                    return false
                }
                
                return true
    }
    
    // Function to save a new trip entry to the TripStore.
    private func saveTripEntry(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yy"
        guard let odometerStart = Double(startOdometer),
              let odometerEnd = Double(endOdometer) else {
            fatalError("Invalid Input! Please fill form fields with appropriate data.")
        }
        let stringDate = dateFormatter.string(from: date)
        let newId = viewModel.records.count + 1
        let tripRecord = Trip(id: newId,
                             tripDate: stringDate,
                             startOdometer: odometerStart,
                             endOdometer: odometerEnd,
                             startLocation: startLocation,
                             endLocation: endLocation,
                             purpose: purpose,
                             notes: notes)
        viewModel.addRecord(tripRecord)
    }
}

// SwiftUI Preview for the TripForm.
struct TripForm_Previews: PreviewProvider {
    static var previews: some View {
        TripForm(viewModel: TripStore())
    }
}
