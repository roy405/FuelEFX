//
//  Exceptions.swift
//  FuelEFX
//
//  Created by Cube on 9/5/23.
//

import Foundation

// Enumeration defining the potential errors that can occur in the store.
enum StoreError: Int, Identifiable, Error, LocalizedError {
    var id: Int { rawValue } // Identifiable conformance, using the raw Int value as ID.
    
    // Enum cases representing different types of errors.
    case loadingFailed = 1
    case nofilefound
    case decodefailed
    case encodeFailed
    
    // Provides a user-friendly description for each error case.
    var errorDescription: String? {
        switch self {
        case .nofilefound: return "No is no filename in Bundle!"
        case .decodefailed: return "Failed to decode data from file!"
        case .loadingFailed: return "Failed to load fuel records!"
        case .encodeFailed: return "Failed to Encode Data to JSON Format, Fatal JSON error!"
        }
    }
}
