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
    @State private var editedTripRecord: Trip
    
    var trip: Trip
    
    init(trip: Trip) {
        self.trip = trip
        self._editedTripRecord = State(initialValue: trip)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Trip Record Details")) {
                Text("Date: \(formattedDate)")
                Text("Start Odometer Reading: \(editedTripRecord.startOdometer)")
                Text("End Odometer Reading: \(editedTripRecord.endOdometer)")
                Text("Start Location: \(editedTripRecord.startLocation)")
                Text("End Location: \(editedTripRecord.endLocation)")
                Text("Purpose: \(editedTripRecord.purpose)")
            }
            
            Section(header: Text("Notes")) {
                Text(editedTripRecord.notes)
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
                deleteTripRecord()
            }
        }
        .navigationBarTitle("Trip Record Details")
    }
    
    private func saveChanges() {
        tripStore.editRecord(editedTripRecord)
        
        isEditing = false
    }
    
    private func deleteTripRecord() {
        tripStore.deleteRecord(editedTripRecord)
    }
    
    private var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: trip.tripDate)
    }
}

struct TripDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let tripStore = TripStore()
        TripDetailView(trip: tripStore.records[0])
    }
}
