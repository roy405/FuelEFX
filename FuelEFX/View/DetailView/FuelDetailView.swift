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
    @State private var editedFuelRecord: Fuel
    
    var fuel: Fuel
    
    init(fuel: Fuel) {
        self.fuel = fuel
        self._editedFuelRecord = State(initialValue: fuel)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Fuel Record Details")) {
                Text("Date: \(formattedDate)")
                Text("Odometer Reading: \(editedFuelRecord.odometerReading)")
                Text("Fuel Amount: \(editedFuelRecord.fuelAmount) liters")
                Text("Fuel Cost: $\(editedFuelRecord.fuelCost)")
                Text("Fuel Type: \(editedFuelRecord.fuelType)")
                Text("Location: \(editedFuelRecord.refillLocation)")
            }
            
            Section(header: Text("Notes")) {
                Text(editedFuelRecord.notes)
            }
            
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
        .navigationBarTitle("Fuel Record Details")
    }
    
    private func saveChanges() {
        fuelStore.editRecord(editedFuelRecord)
        
        isEditing = false
    }
    
    private func deleteFuelRecord() {
        fuelStore.deleteRecord(editedFuelRecord)
    }
    
    private var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: fuel.refillDate)
    }
}

struct FuelDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let fuelStore = FuelStore()
        FuelDetailView(fuel: fuelStore.records[0])
    }
}
