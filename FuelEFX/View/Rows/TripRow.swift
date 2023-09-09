//
//  TripRow.swift
//  FuelEFX
//
//  Created by Cube on 9/3/23.
//

import SwiftUI

// A SwiftUI view representing a single trip record in a row format.
struct TripRecordRow: View {
    @Binding var tripRecord: Trip // A binding to the trip record displayed by this view.
    var tripStore: TripStore // The store containing all trip records.
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Trip Date:")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                Text(tripRecord.tripDate)
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("Destination:")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                Text(tripRecord.endLocation)
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
            }
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("Trip Purpose:")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                Text(tripRecord.purpose)
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
struct TripRecordRow_Previews: PreviewProvider {
    static var previews: some View {
        let tripStore = TripStore()
        TripRecordRow(tripRecord: .constant(tripStore.records[0]), tripStore: tripStore).previewLayout(.sizeThatFits)
    }
}
