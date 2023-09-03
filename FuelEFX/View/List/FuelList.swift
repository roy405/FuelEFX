//
//  FuelListView.swift
//  FuelEFX
//
//  Created by Cube on 9/3/23.
//

import SwiftUI

struct FuelList: View {
    @ObservedObject var viewModel: FuelStore
    
    var body: some View {
        List{
            ForEach(viewModel.records.indices, id: \.self) { index in
                NavigationLink(destination: FuelDetailView(fuel: viewModel.records[index])) {
                    FuelRecordRow(fuelRecord: $viewModel.records[index], fuelStore: viewModel)
                }
            }
        }
    }
}

struct FuelList_Previews: PreviewProvider {
    static var previews: some View {
        FuelList(viewModel: FuelStore())
    }
}
