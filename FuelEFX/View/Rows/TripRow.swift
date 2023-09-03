//
//  TripRow.swift
//  FuelEFX
//
//  Created by Cube on 9/3/23.
//

import SwiftUI

struct TripRecordRow: View {
    @Binding var tripRecord: Trip
    var tripStore: TripStore
    
    var body: some View {
        HStack {
            Text("Trip Date: \(tripRecord.tripDate)")
            Spacer()
            Text("Fuel Amount: \(tripRecord.endLocation)")
            Text("Trip Purpose\(tripRecord.purpose)")
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

struct TripRecordRow_Previews: PreviewProvider {
    static var previews: some View {
        let tripStore = TripStore()
        TripRecordRow(tripRecord: .constant(tripStore.records[0]), tripStore: tripStore).previewLayout(.sizeThatFits)
    }
}
