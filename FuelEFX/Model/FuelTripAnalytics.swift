//
//  FuelTripAnalytics.swift
//  FuelEFX
//
//  Created by Cube on 9/9/23.
//

import Foundation

class FuelAnalytics: Identifiable, Codable {
    let id: Int
    
    // The FuelAnalytics class leverages the OOP Concept composition and hence is composed of the Trip and Fuel Classes.
    // The FuelAnalytics class further leverages the Aggregation by being composed of the whole being the larger whole
    // of the two isolated parts (Fuel and Trip) to utilize and provide meaningful analytics
    let trip: Trip
    var refuels: [Fuel]
    
    //Class Initializer
    init(id: Int, trip: Trip, refuels: [Fuel]) {
        self.id = id
        self.trip = trip
        self.refuels = refuels
    }
    
    // Method to calculate total fuel cost for the trip
    func totalFuelCost() -> Double {
        return refuels.reduce(0) { $0 + $1.fuelCost }
    }
    
    // Method to calculate average fuel consumption for the trip (liters per 100km or similar)
    func averageFuelConsumption() -> Double? {
        let totalFuel = refuels.reduce(0) { $0 + $1.fuelAmount }
        let distanceTraveled = trip.endOdometer - trip.startOdometer
        if distanceTraveled <= 0 { return nil } // handle edge cases, e.g., no distance traveled or negative values
        return (totalFuel / distanceTraveled) * 100
    }
    
}
