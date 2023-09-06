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
                if isValidInput(){
                    saveFuelEntry()
                }
                
            }
        }
        .navigationTitle("Add Fuel Entry")
        // Configuring the alert.
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // Function to validate user input before saving.
    private func isValidInput() -> Bool {
        if odometerReading.isEmpty || fuelAmount.isEmpty || fuelCost.isEmpty || fuelType.isEmpty || location.isEmpty {
            alertTitle = "Validation Error"
            alertMessage = "All fields are required. Please fill them out before saving."
            showAlert = true
            return false
        }
        
        guard let _ = Double(odometerReading), let _ = Double(fuelAmount), let _ = Double(fuelCost) else {
            alertTitle = "Input Error"
            alertMessage = "Odometer reading, fuel amount, and fuel cost must be valid numbers."
            showAlert = true
            return false
        }
        return true
    }
    
    // Function to save a new fuel entry to the FuelStore
    private func saveFuelEntry() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yy"
        guard let odometer = Double(odometerReading),
              let amount = Double(fuelAmount),
              let cost = Double(fuelCost) else {
            alertTitle = "Input Error"
            alertMessage = "Start and End Odometer readings must be valid numbers."
            showAlert = true
            return
        }
        
        let stringDate = dateFormatter.string(from: date)
        let newId = viewModel.records.count + 1
        
        let fuelRecord = Fuel(id: newId,
                              refillDate: stringDate,
                              odometerReading: odometer,
                              fuelAmount: amount,
                              fuelCost: cost,
                              fuelType: fuelType,
                              refillLocation: location,
                              notes: notes)
        
        viewModel.addRecord(fuelRecord)
        
        alertTitle = "Success"
        alertMessage = "Fuel entry has been saved successfully."
        showAlert = true
        
        // Clear the form fields after saving
        date = Date()
        odometerReading = ""
        fuelAmount = ""
        fuelCost = ""
        fuelType = ""
        location = ""
        notes = ""
    }
}

// SwiftUI Preview for the FuelForm.
struct FuelForm_Previews: PreviewProvider {
    static var previews: some View {
        FuelForm(viewModel: FuelStore())
    }
}
