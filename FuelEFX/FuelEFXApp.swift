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
                        Label("Home", systemImage: "home")
                    }
                    NavigationView {
                        FuelList(viewModel: fuelStore)
                    }
                    .tabItem {
                        Label("Fuel List", systemImage: "drop.fill")
                    }
                    
                    NavigationView {
                        TripList(viewModel: tripStore)
                    }
                    .tabItem {
                        Label("Trip History", systemImage: "car.fill")
                    }
                }
            }
        }
}
