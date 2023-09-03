//
//  Fuel.swift
//  FuelEffix
//
//  Created by Cube on 9/1/23.
//

import Foundation

// Define a class named Fuel that conforms to the Identifiable and Codable protocols.
class Fuel: Identifiable, Codable {
    // Properties of the Fuel class.
    let id: Int
    let refillDateString: String
    let refillDate: Date
    let odometerReading: Double
    let fuelAmount: Double
    let fuelCost: Double
    let fuelType: String
    let refillLocation: String
    let notes: String
    
    // Initialize the Fuel object with provided values.
    init(id: Int, refillDate: String, odometerReading: Double, fuelAmount: Double, fuelCost: Double, fuelType: String, refillLocation: String, notes: String){
        self.id = id
        // Create a DateFormatter to parse the refillDate string to appropriate format.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yy"
        self.refillDate = dateFormatter.date(from: refillDate)!
        self.refillDateString = refillDate
        self.odometerReading = odometerReading
        self.fuelAmount = fuelAmount
        self.fuelCost = fuelCost
        self.fuelType = fuelType
        self.refillLocation = refillLocation
        self.notes = notes
    }
}

