//
//  FuelForm.swift
//  FuelEFX
//
//  Created by Cube on 9/3/23.
//

import SwiftUI

struct FuelForm: View {
    @ObservedObject var viewModel: FuelStore
    
    @State private var date = Date()
    @State private var odometerReading = ""
    @State private var fuelAmount = ""
    @State private var fuelCost = ""
    @State private var fuelType = ""
    @State private var location = ""
    @State private var notes = ""
    
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
                saveFuelEntry()
            }
        }
        .navigationTitle("Add Fuel Entry")
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
        
        let fuelRecord = Fuel(id: 0, refillDate: stringDate, odometerReading: odometer, fuelAmount: amount, fuelCost: cost, fuelType: fuelType, refillLocation: location, notes: notes)
        
        viewModel.addRecord(fuelRecord)
    }
}

struct FuelForm_Previews: PreviewProvider {
    static var previews: some View {
        FuelForm(viewModel: FuelStore())
    }
}
