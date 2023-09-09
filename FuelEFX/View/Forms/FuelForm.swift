//
//  FuelForm.swift
//  FuelEFX
//
//  Created by Cube on 9/3/23.
//

import SwiftUI

//SwiftUI view representing a form to input fuel details.
struct FuelForm: View {
    @EnvironmentObject var fuelStore: FuelStore //ViewModel to manage trip records
    @ObservedObject var viewModel: FuelStore
    
    // State properties to hold user input.
    @State private var date = Date()
    @State private var odometerReading = ""
    @State private var fuelAmount = ""
    @State private var fuelCost = ""
    @State private var fuelType = ""
    @State private var location = ""
    @State private var notes = ""
    
    // State properties for displaying alerts.
    @State private var showAlert = false
    @State private var alertTitle = "Error"
    @State private var alertMessage = "An error occured"
    
    var body: some View {
        Form {
            Section(header: Text("Fuel Entry Details")) {
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Odometer Reading", text: $odometerReading)
                    .keyboardType(.numberPad)
                TextField("Fuel Amount", text: $fuelAmount)
                    .keyboardType(.decimalPad)
                TextField("Fuel Cost", text: $fuelCost)
                    .keyboardType(.decimalPad)
                TextField("Fuel Type", text: $fuelType)
                TextField("Location", text: $location)
            }
            
            Section(header: Text("Notes")) {
                TextEditor(text: $notes)
                    .frame(height: 100)
            }
            //Button to save fuel details after validation
            Button("Save") {
                let validation = viewModel.isValidInput(odometerReading: odometerReading, fuelAmount: fuelAmount, fuelCost: fuelCost, fuelType: fuelType, location: location)
                if validation.0 {
                    let result = viewModel.saveFuelEntry(date: date, odometerReading: odometerReading, fuelAmount: fuelAmount, fuelCost: fuelCost, fuelType: fuelType, location: location, notes: notes)
                    alertTitle = result.title
                    alertMessage = result.message
                    showAlert = true
                    
                    // Clear the form fields after saving
                    date = Date()
                    odometerReading = ""
                    fuelAmount = ""
                    fuelCost = ""
                    fuelType = ""
                    location = ""
                    notes = ""
                } else {
                    alertTitle = validation.title
                    alertMessage = validation.message
                    showAlert = true
                }
            }
        }
        .navigationTitle("Add Fuel Entry")
        // Configuring the alert.
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

// SwiftUI Preview for the FuelForm.
struct FuelForm_Previews: PreviewProvider {
    static var previews: some View {
        FuelForm(viewModel: FuelStore())
    }
}
