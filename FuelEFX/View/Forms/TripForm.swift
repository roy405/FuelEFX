//
//  TripForm.swift
//  FuelEFX
//
//  Created by Cube on 9/3/23.
//

import SwiftUI

struct TripForm: View {
    @ObservedObject var viewModel: TripStore
    
    @State private var date = Date()
    @State private var startOdometer = ""
    @State private var endOdometer = ""
    @State private var startLocation = ""
    @State private var endLocation = ""
    @State private var purpose = ""
    @State private var notes = ""
    
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
            
            Button("Save") {
                saveTripEntry()
            }
        }
        .navigationTitle("Add Fuel Entry")
      }
    
    private func saveTripEntry(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yy"
        guard let odometerStart = Double(startOdometer),
              let odometerEnd = Double(endOdometer) else {
            fatalError("Invalid Input! Please fill form fields with appropriate data.")
        }
        let stringDate = dateFormatter.string(from: date)
        
        let tripRecord = Trip(id: 0,
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


struct TripForm_Previews: PreviewProvider {
    static var previews: some View {
        TripForm(viewModel: TripStore())
    }
}
