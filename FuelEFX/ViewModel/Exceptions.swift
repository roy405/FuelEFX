//
//  Exceptions.swift
//  FuelEFX
//
//  Created by Cube on 9/5/23.
//

import Foundation

enum StoreError: Int, Identifiable, Error, LocalizedError {
    var id: Int { rawValue }

    case loadingFailed = 1
    case nofilefound
    case decodefailed
    case encodeFailed
    
    var errorDescription: String? {
        switch self {
        case .nofilefound: return "No is no filename in Bundle!"
        case .decodefailed: return "Failed to decode data from file!"
        case .loadingFailed: return "Failed to load fuel records!"
        case .encodeFailed: return "Failed to Encode Data to JSON Format, Fatal JSON error!"
        }
    }
}
