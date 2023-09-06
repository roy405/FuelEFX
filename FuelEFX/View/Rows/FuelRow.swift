//
//  FuelRow.swift
//  FuelEFX
//
//  Created by Cube on 9/3/23.
//

import SwiftUI

// A SwiftUI view representing a single fuel record in a row format.
struct FuelRecordRow: View {
    @Binding var fuelRecord: Fuel // A binding to the fuel record displayed by this view.
    var fuelStore: FuelStore // The store containing all fuel records.
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Trip Date:")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                Text(fuelRecord.refillDate)
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("Fuel Cost:")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                Text("$\(fuelRecord.fuelCost, specifier: "%.2f")")
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
            }
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("Refill Location:")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                Text(fuelRecord.refillLocation)
                    .font(.system(size: 14)) 
                    .fontWeight(.semibold)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }

    // DateFormatter to format trip dates.
    private var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter
    }
}

// SwiftUI Preview for the TripRecordRow view.
struct FuelRecordRow_Previews: PreviewProvider {
    static var previews: some View {
        let fuelStore = FuelStore()
        FuelRecordRow(fuelRecord: .constant(fuelStore.records[0]), fuelStore: fuelStore).previewLayout(.sizeThatFits)
    }
}
