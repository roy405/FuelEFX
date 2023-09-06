//
//  TripList.swift
//  FuelEFX
//
//  Created by Cube on 9/3/23.
//

import SwiftUI

// SwiftUI view that represents a list of trip records.
struct TripList: View {
    @ObservedObject var viewModel: TripStore // ViewModel to manage trip records.
    
    var body: some View {
        List{
            // Looping through all the records in the viewModel to display each one.
            ForEach(viewModel.records.indices, id: \.self) { index in
                // NavigationLink to navigate to the details of a selected trip record.
                NavigationLink(destination: TripDetailView(trip: viewModel.records[index])) {
                    // Each row in the list represents a trip record.
                    TripRecordRow(tripRecord: $viewModel.records[index], tripStore: viewModel)
                }
            }
        }
        // Alert to show any errors that might occur.
        .alert(item: $viewModel.tripError) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

// SwiftUI Preview for the TripList.
struct TripList_Previews: PreviewProvider {
    static var previews: some View {
        TripList(viewModel: TripStore())
    }
}
