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
                FuelList(viewModel: fuelStore)
                .navigationTitle("Fuel Refill History")
            }
            .tabItem {
                Label("Fuel List", systemImage: "list.clipboard")
                }
            NavigationView {
                // Trip List View
                TripList(viewModel: tripStore)
                .navigationTitle("Trip History")
            }
            .tabItem {
                Label("Trip History", systemImage: "doc.fill")
                }
            NavigationView {
                // Trip Form View
                TripForm(viewModel: tripStore)
            }
            .tabItem{
                Label("Add Trip", systemImage:"road.lanes.curved.left")
                }
            NavigationView{
                // Fuel Form View
                FuelForm(viewModel: fuelStore)
            }
            .tabItem{
                Label("Add Fuel", systemImage: "fuelpump.circle.fill")
                }
            }
        }
    }
}
