//
//  TripList.swift
//  FuelEFX
//
//  Created by Cube on 9/3/23.
//

import SwiftUI

struct TripList: View {
    @ObservedObject var viewModel: TripStore
    
    var body: some View {
        List{
            ForEach(viewModel.records.indices, id: \.self) { index in
                NavigationLink(destination: TripDetailView(trip: viewModel.records[index])) {
                    TripRecordRow(tripRecord: $viewModel.records[index], tripStore: viewModel)
                }
            }
        }.alert(item: $viewModel.tripError) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct TripList_Previews: PreviewProvider {
    static var previews: some View {
        TripList(viewModel: TripStore())
    }
}
