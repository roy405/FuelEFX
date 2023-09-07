//
//  FuelEFXApp.swift
//  FuelEFX
//
//  Created by Cube on 9/3/23.
//

import SwiftUI
// Main application entry-point
@main
struct FuelEFXApp: App {
    @StateObject private var fuelStore = FuelStore() //Fuel Viewmodel
    @StateObject private var tripStore = TripStore() //Trup Viewmodel
        
    var body: some Scene {
        WindowGroup {
            //Tab-based navigation for the overall application
            TabView {
                ScrollView{
                    // Home (Dashboard) View with all Charts
                    Home()
                }
            .tabItem{
            Label("Home", systemImage: "house.fill")
                }
            NavigationView {
                // Fuel List View
                FuelList()
                .navigationTitle("Fuel Refill History")
            }
            .environmentObject(fuelStore)
            .tabItem {
                Label("Fuel List", systemImage: "list.clipboard")
                }
            NavigationView {
                // Trip List View
                TripList()
                .navigationTitle("Trip History")
            }
            .environmentObject(tripStore)
            .tabItem {
                Label("Trip History", systemImage: "doc.fill")
                }
            NavigationView {
                // Trip Form View
                TripForm(viewModel: tripStore)
            }
            .environmentObject(tripStore)
            .tabItem{
                Label("Add Trip", systemImage:"road.lanes.curved.left")
                }
            NavigationView{
                // Fuel Form View
                FuelForm(viewModel: fuelStore)
            }
            .environmentObject(fuelStore)
            .tabItem{
                Label("Add Fuel", systemImage: "fuelpump.circle.fill")
                }
            }
        }
    }
}
