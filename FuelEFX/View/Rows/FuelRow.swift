//
//  FuelRow.swift
//  FuelEFX
//
//  Created by Cube on 9/3/23.
//

import SwiftUI

struct FuelRecordRow: View {
    @Binding var fuelRecord: Fuel
    var fuelStore: FuelStore
    
    var body: some View {
        HStack {
            Text("Trip Date: \(fuelRecord.refillDate)")
            Spacer()
            Text("Fuel Cost: $\(fuelRecord.fuelCost)")
            Text("Refill Location: \(fuelRecord.refillLocation)")
        }
            .padding(.vertical, 8)
    }
    
    private var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter
    }
}

struct FuelRecordRow_Previews: PreviewProvider {
    static var previews: some View {
        let fuelStore = FuelStore()
        FuelRecordRow(fuelRecord: .constant(fuelStore.records[0]), fuelStore: fuelStore).previewLayout(.sizeThatFits)
    }
}
