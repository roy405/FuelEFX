//
//  Home.swift
//  FuelEFX
//
//  Created by Cube on 9/3/23.
//

import SwiftUI
import SwiftUICharts

struct Home: View {
    // Observed Objects of both trip and fuel viewmodels
    @ObservedObject var tripStore = TripStore()
    @ObservedObject var fuelStore = FuelStore()
    
    // State variable used to listen to updates
    @State private var updateView = false
    
    // Calculate the average fuel consumption for all trips
    var averageFuelConsumptions: [Double] {
        // Map each trip to its average fuel consumption.
        tripStore.records.map { trip in
            // Filter the fuel records for refuels that occurred during the trip, based on odometer readings.
            let refuelsForThisTrip = fuelStore.records.filter { $0.odometerReading >= trip.startOdometer && $0.odometerReading <= trip.endOdometer }
            // Sum up the fuel amounts for the refuels that occurred during this trip.
            let totalFuel = refuelsForThisTrip.reduce(0) { $0 + $1.fuelAmount }
            // Calculate the total distance traveled during this trip.
            let distanceTraveled = trip.endOdometer - trip.startOdometer
            // If the distance traveled is zero or negative, return 0 as the average fuel consumption to avoid division by zero.
            if distanceTraveled <= 0 { return 0.0 }
            // Return the average fuel consumption for this trip in liters per 100 km.
            return (totalFuel / distanceTraveled) * 100
        }
    }
    
    // Calculate the total fuel cost for all trips
    var totalFuelCosts: [(String, Double)] {
        // Map each trip to a tuple containing its ID and the total fuel cost for that trip.
        tripStore.records.map { trip in
            // Filter the refuels based on the odometer reading to find refuels specific to this trip.
            let refuelsForThisTrip = fuelStore.records.filter { $0.odometerReading >= trip.startOdometer && $0.odometerReading <= trip.endOdometer }
            // Calculate the total fuel cost for this trip by summing up the fuel costs of filtered refuels.
            return ("Trip \(trip.id)", refuelsForThisTrip.reduce(0) { $0 + $1.fuelCost })
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Line Chart View for Average Fuel Consumption
                VStack(alignment: .leading) {
                    LineView(data: averageFuelConsumptions, title: "Average Fuel Consumption", legend: "Liters per 100km")
                        .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height * 0.4, maxHeight: UIScreen.main.bounds.height * 0.4)
                        .padding([.horizontal, .bottom])
                }
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 4)
                .padding(.horizontal)
                
                // Bar Chart View for Total Fuel Cost
                VStack(alignment: .leading, spacing: 10) {
                    Text("Bar Chart - Total Fuel Cost")
                        .font(.headline)
                        .padding(.top)
                    
                    BarChartView(data: ChartData(values: totalFuelCosts), title: "Fuel Cost", legend: "Total Cost")
                        .frame(minWidth: 0, maxWidth: .infinity)
                    // You can remove the padding here to give the chart more space
                }
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 4)
                .padding(.horizontal)
            }
            .padding(.bottom, 20)
            // the onReceive properites carry out forced updates and redrawings based on data updates on the viewmodels
            .onReceive(tripStore.$records) { _ in
                self.updateView.toggle()
            }
            .onReceive(fuelStore.$records) { _ in
                self.updateView.toggle()
            }
        }
    }
    
}


// SwiftUI Preview for the Home(charts).
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
