//
//  FuelEFXApp.swift
//  FuelEFX
//
//  Created by Cube on 9/3/23.
//

import SwiftUI

@main
struct FuelEFXApp: App {
    @StateObject private var fuelStore = FuelStore()
    @StateObject private var tripStore = TripStore()
        
    var body: some Scene {
        WindowGroup {
            TabView {
                ScrollView{
                    Home()
                }
            .tabItem{
            Label("Home", systemImage: "house.fill")
                }
            NavigationView {
                FuelList(viewModel: fuelStore)
                .navigationTitle("Fuel Refill History")
            }
            .tabItem {
                Label("Fuel List", systemImage: "list.clipboard")
                }
                    
            NavigationView {
                TripList(viewModel: tripStore)
                .navigationTitle("Trip History")
            }
            .tabItem {
                Label("Trip History", systemImage: "doc.fill")
                }
            NavigationView {
                    TripForm(viewModel: tripStore)
                }
            .tabItem{
                    Label("Add Trip", systemImage:"road.lanes.curved.left")
                }
                NavigationView{
                    FuelForm(viewModel: fuelStore)
                }
                .tabItem{
                    Label("Add Fuel", systemImage: "fuelpump.circle.fill")
                }
            }
        }
    }
}
