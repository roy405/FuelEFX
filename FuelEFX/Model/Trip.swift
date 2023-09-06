//
//  Trip.swift
//  FuelEffix
//
//  Created by Cube on 9/1/23.
//

import Foundation

// Define a class named Trip that conforms to the Identifiable and Codable protocols.
class Trip: Identifiable, Codable {
    // Properties of the Fuel class.
    let id: Int
    let tripDate: String
    let startOdometer: Double
    let endOdometer: Double
    let startLocation: String
    let endLocation: String
    let purpose: String
    let notes: String
 
    // Initialize the Fuel object with provided values.
    init(id: Int, tripDate: String, startOdometer: Double, endOdometer: Double, startLocation: String, endLocation: String, purpose: String, notes: String){
        self.id = id
        // Create a DateFormatter to parse the refillDate string to appropriate format.
        self.tripDate = tripDate
        self.startOdometer = startOdometer
        self.endOdometer = endOdometer
        self.startLocation = startLocation
        self.endLocation = endLocation
        self.purpose = purpose
        self.notes = notes
        
    }
}
