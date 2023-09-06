//
//  FuelForm.swift
//  FuelEFX
//
//  Created by Cube on 9/3/23.
//

import SwiftUI

struct FuelForm: View {
    @EnvironmentObject var fuelStore: FuelStore
    @ObservedObject var viewModel: FuelStore
    
    @State private var date = Date()
    @State private var odometerReading = ""
    @State private var fuelAmount = ""
    @State private var fuelCost = ""
    @State private var fuelType = ""
    @State private var location = ""
    @State private var notes = ""
    
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
            
            Button("Save") {
                if isValidInput(){
                    saveFuelEntry()
                }
                
            }
        }
        .navigationTitle("Add Fuel Entry")
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
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
        
    private func saveFuelEntry() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yy"
        guard let odometer = Double(odometerReading),
              let amount = Double(fuelAmount),
              let cost = Double(fuelCost) else {
            // Handle invalid input
            fatalError("Invalid Input! Please fill form fields with appropriate data.")
        }
        
        let stringDate = dateFormatter.string(from: date)
        let newId = viewModel.records.count + 1
        
        let fuelRecord = Fuel(id: newId, refillDate: stringDate, odometerReading: odometer, fuelAmount: amount, fuelCost: cost, fuelType: fuelType, refillLocation: location, notes: notes)
        
        viewModel.addRecord(fuelRecord)
    }
}

struct FuelForm_Previews: PreviewProvider {
    static var previews: some View {
        FuelForm(viewModel: FuelStore())
    }
}
