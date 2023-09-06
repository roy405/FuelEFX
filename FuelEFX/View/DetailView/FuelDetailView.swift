//
//  FuelDetailView.swift
//  FuelEFX
//
//  Created by Cube on 9/3/23.
//

import SwiftUI

struct FuelDetailView: View {
    @EnvironmentObject var fuelStore: FuelStore
    @State private var isEditing = false
    
    // Make these @State properties so they can be edited
    @State private var refillDate: String
    @State private var odometerReading: String
    @State private var fuelAmount: String
    @State private var fuelCost: String
    @State private var fuelType: String
    @State private var refillLocation: String
    @State private var notes: String
        
    var fuel: Fuel
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    init(fuel: Fuel) {
        self.fuel = fuel
        _refillDate = State(initialValue: fuel.refillDate)
        _odometerReading = State(initialValue: "\(fuel.odometerReading)")
        _fuelAmount = State(initialValue: "\(fuel.fuelAmount)")
        _fuelCost = State(initialValue: "\(fuel.fuelCost)")
        _fuelType = State(initialValue: fuel.fuelType)
        _refillLocation = State(initialValue: fuel.refillLocation)
        _notes = State(initialValue: fuel.notes)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Fuel Record Details")) {
                if isEditing {
                    Group {
                        TextField("Date", text: $refillDate)
                        TextField("Odometer Reading", text: $odometerReading)
                        TextField("Fuel Amount", text: $fuelAmount)
                        TextField("Fuel Cost", text: $fuelCost)
                    }
                    
                    Group {
                        TextField("Fuel Type", text: $fuelType)
                        TextField("Location", text: $refillLocation)
                    }
                } else {
                    Group {
                        Text("Date: \(refillDate)")
                        Text("Odometer Reading: \(odometerReading)")
                        Text("Fuel Amount: \(fuelAmount) liters")
                        Text("Fuel Cost: $\(fuelCost)")
                    }
                    
                    Group {
                        Text("Fuel Type: \(fuelType)")
                        Text("Location: \(refillLocation)")
                    }
                }
            }
            
            Section(header: Text("Notes")) {
                if isEditing {
                    ZStack(alignment: .topLeading) {
                        if notes.isEmpty {
                            Text("Notes").foregroundColor(.gray)
                        }
                        TextEditor(text: $notes)
                            .frame(height: 100)
                    }
                } else {
                    Text(notes)
                }
            }
    
            Group {
                if isEditing {
                    Button("Save Changes") {
                        saveChanges()
                    }
                } else {
                    Button("Edit") {
                        isEditing = true
                    }
                }

                Button("Delete") {
                    deleteFuelRecord()
                }
            }
        }
        .alert(isPresented: $showAlert){
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .navigationBarTitle("Fuel Record Details")
    }

    private func saveChanges() {
        guard validateFields()else{
            return
        }
        
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
        
        fuelStore.editRecord(editedFuelRecord)
        isEditing = false
    }
    
    private func validateFields() -> Bool {
        // Simple validations. You can expand on these as needed.
        guard !refillDate.isEmpty, !fuelType.isEmpty, !refillLocation.isEmpty else {
            alertTitle = "Missing Fields"
            alertMessage = "Please fill all the fields."
            showAlert = true
            return false
        }
        
        guard Double(odometerReading) != nil, Double(fuelAmount) != nil, Double(fuelCost) != nil else {
            alertTitle = "Invalid Input"
            alertMessage = "Please ensure Odometer Reading, Fuel Amount and Fuel Cost fields contain valid numbers."
            showAlert = true
            return false
        }
        
        return true
    }
    
    private func deleteFuelRecord() {
        fuelStore.deleteRecord(fuel)
    }
}

struct FuelDetailView_Previews: PreviewProvider {
    static var previews: some View{
        let fuelStore = FuelStore()
        FuelDetailView(fuel: fuelStore.records[0])
    }
}
