//
//  FuelDetailView.swift
//  FuelEFX
//
//  Created by Cube on 9/3/23.
//

import SwiftUI

// A SwiftUI view displaying detailed information about a specific fuel record.
struct FuelDetailView: View {
    @EnvironmentObject var fuelStore: FuelStore // The main store for fuel records.
    @State private var isEditing = false // State to track whether the view is in editing mode.
    
    // State properties to hold editable fields.
    @State private var refillDate: String
    @State private var odometerReading: String
    @State private var fuelAmount: String
    @State private var fuelCost: String
    @State private var fuelType: String
    @State private var refillLocation: String
    @State private var notes: String
        
    var fuel: Fuel // The fuel record being displayed/edited.
    
    // State properties for displaying alerts.
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    // Initializing the view with a fuel record and setting initial values for editable fields.
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
    
           // Buttons for editing, saving, and deleting fuel records.
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
        // Configuring alert and navigation bar title.
        .alert(isPresented: $showAlert){
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .navigationBarTitle("Fuel Record Details")
    }

    // Function to save changes made to the fuel record.
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
    
    // Function to validate the fields before saving.
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
    
    // Function to delete the current fuel record.
    private func deleteFuelRecord() {
        fuelStore.deleteRecord(fuel)
    }
}

// SwiftUI Preview for the FuelDetailView.
struct FuelDetailView_Previews: PreviewProvider {
    static var previews: some View{
        let fuelStore = FuelStore()
        FuelDetailView(fuel: fuelStore.records[0])
    }
}
