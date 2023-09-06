//
//  TripDetailView.swift
//  FuelEFX
//
//  Created by Cube on 9/3/23.
//

import SwiftUI

struct TripDetailView: View {
    @EnvironmentObject var tripStore: TripStore
    @State private var isEditing = false
    
    // Make these @State properties so they can be edited
    @State private var tripDate: String
    @State private var startOdometer: String
    @State private var endOdometer: String
    @State private var startLocation: String
    @State private var endLocation: String
    @State private var purpose: String
    @State private var notes: String
    
    var trip: Trip
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    init(trip: Trip) {
        self.trip = trip
        _tripDate = State(initialValue: trip.tripDate)
        _startOdometer = State(initialValue: "\(trip.startOdometer)")
        _endOdometer = State(initialValue: "\(trip.endOdometer)")
        _startLocation = State(initialValue: trip.startLocation)
        _endLocation = State(initialValue: trip.endLocation)
        _purpose = State(initialValue: trip.purpose)
        _notes = State(initialValue: trip.notes)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Trip Record Details")){
                if isEditing {
                    Group {
                        TextField("Date", text: $tripDate)
                        TextField("Start Odometer", text: $startOdometer)
                        TextField("End Odometer", text: $endOdometer)
                        TextField("Start Location", text: $startLocation)
                        TextField("End Location", text: $endLocation)
                        TextField("Purpose", text: $purpose)
                    }
                } else {
                    Group {
                        Text("Date: \(tripDate)")
                        Text("Start Odometer: \(startOdometer)")
                        Text("End Odometer: \(endOdometer)")
                        Text("Start Location: \(startLocation)")
                        Text("End Location: \(endLocation)")
                        Text("Purpose: \(purpose)")
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
                    deleteTripRecord()
                }
            }
            .alert(isPresented: $showAlert){
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }.navigationBarTitle("Trip Record Details")
    }
    
    

    
    private func saveChanges() {
        guard validateFields()else{
            return
        }
        
        let editedTripRecord = Trip(
            id: trip.id,
            tripDate: tripDate,
            startOdometer: Double(startOdometer) ?? 0.0,
            endOdometer: Double(endOdometer) ?? 0.0,
            startLocation: startLocation,
            endLocation: endLocation,
            purpose: purpose,
            notes: notes
        )
        tripStore.editRecord(editedTripRecord)
        isEditing = false
    }
    
    private func validateFields() -> Bool {
        guard !tripDate.isEmpty, !startLocation.isEmpty, !endLocation.isEmpty, !purpose.isEmpty else {
            alertTitle = "Missing Fields"
            alertMessage = "Please fill all the fields"
            showAlert = true
            return false
        }
        
        guard Double(startOdometer) != nil, Double(endLocation) != nil else {
            alertTitle = "Invalid Input"
            alertMessage = "Please ensure Start and End Odometer fields contain valid numbers."
            showAlert = true
            return false
        }
        
        return true
    }
    
    private func deleteTripRecord() {
        tripStore.deleteRecord(trip)
    }
}

struct TripDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let tripStore = TripStore()
        TripDetailView(trip: tripStore.records[0])
    }
}
