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
