//
//  FuelListView.swift
//  FuelEFX
//
//  Created by Cube on 9/3/23.
//

import SwiftUI

// SwiftUI view that represents a list of fuel records.
struct FuelList: View {
    @EnvironmentObject var viewModel: FuelStore // ViewModel to manage fuel records.
    
    var body: some View {
        List{
            // Looping through all the records in the viewModel to display each one.
            ForEach(viewModel.records.indices, id: \.self) { index in
                // NavigationLink to navigate to the details of a selected fuel record.
                NavigationLink(destination: FuelDetailView(fuel: viewModel.records[index])) {
                    // Each row in the list represents a fuel record.
                    FuelRecordRow(fuelRecord: $viewModel.records[index], fuelStore: viewModel)
                }
            }
        }
        // Alert to show any errors that might occur.
        .alert(item: $viewModel.fuelError) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

// SwiftUI Preview for the FuelList.
struct FuelList_Previews: PreviewProvider {
    static var previews: some View {
        FuelList().environmentObject(FuelStore())
    }
}
