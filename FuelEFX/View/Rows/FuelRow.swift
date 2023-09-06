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
            VStack(alignment: .leading, spacing: 4) {
                Text("Trip Date:")
                    .font(.system(size: 12)) // Smaller label font size
                    .foregroundColor(.secondary)
                Text(fuelRecord.refillDate)
                    .font(.system(size: 14)) // Smaller value font size
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("Fuel Cost:")
                    .font(.system(size: 12)) // Smaller label font size
                    .foregroundColor(.secondary)
                Text("$\(fuelRecord.fuelCost, specifier: "%.2f")")
                    .font(.system(size: 14)) // Smaller value font size
                    .fontWeight(.semibold)
            }
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("Refill Location:")
                    .font(.system(size: 12)) // Smaller label font size
                    .foregroundColor(.secondary)
                Text(fuelRecord.refillLocation)
                    .font(.system(size: 14)) // Smaller value font size
                    .fontWeight(.semibold)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
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
