//
//  Home.swift
//  FuelEFX
//
//  Created by Cube on 9/3/23.
//

import SwiftUI

struct Home: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("SwiftUI Charts")
                .font(.largeTitle)
                .padding(.top, 20)
                        
                // First Chart View
                VStack {
                    Text("Line Chart")
                        .font(.title)

                }
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 4)
                        
                // Second Chart View
                VStack {
                    Text("Pie Chart")
                        .font(.title)
                }
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 4)
                        
                Spacer()
            }
        .padding()
        }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
