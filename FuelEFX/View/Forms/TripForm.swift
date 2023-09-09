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
                let validationResult = viewModel.isValidInput(startOdometer: startOdometer, endOdometer: endOdometer, startLocation: startLocation, endLocation: endLocation, purpose: purpose)
                
                if validationResult.0 {
                    let saveResult = viewModel.saveTripEntry(date: date, startOdometer: startOdometer, endOdometer: endOdometer, startLocation: startLocation, endLocation: endLocation, purpose: purpose, notes: notes)
                    
                    alertTitle = saveResult.title
                    alertMessage = saveResult.message
                    showAlert = true
                    
                    if saveResult.0 { // if saved successfully
                        // Clear the form fields
                        date = Date()
                        startOdometer = ""
                        endOdometer = ""
                        startLocation = ""
                        endLocation = ""
                        purpose = ""
                        notes = ""
                    }
                } else {
                    alertTitle = validationResult.title
                    alertMessage = validationResult.message
                    showAlert = true
                }
            }
        }
        .navigationTitle("Add Trip Entry")
        // Configuring the alert.
        .alert(isPresented: $showAlert){
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

// SwiftUI Preview for the TripForm.
struct TripForm_Previews: PreviewProvider {
    static var previews: some View {
        TripForm(viewModel: TripStore())
    }
}
