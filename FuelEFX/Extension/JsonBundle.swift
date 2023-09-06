//
//  JsonBundle.swift
//  FuelEFX
//
//  Created by Cube on 9/3/23.
//

import Foundation

// Extending the Bundle class to add functionality for decoding and encoding data.
extension Bundle {
    /// Decodes the specified file's content into an object of the given type.
    ///
    /// - Parameters:
    /// - filename: The name of the file to be decoded.
    /// - type: The type of the object to be decoded.
    /// - Returns: The decoded object of the given type.
    /// - Throws: An error if there is an issue with locating the file, reading its data, or decoding its contents.
    func decode<T: Decodable>(url: URL, as type: T.Type) throws -> T {
        // Attempt to retrieve data from the URL.
      guard let data = try? Data(contentsOf: url) else {
          throw StoreError.loadingFailed
      }
        // Attempt to decode the data into the given type.
      guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
          throw StoreError.decodefailed
      }
      return decodedData
    }
    /// Encodes the specified object into a Data object.
    ///
    /// - Parameter object: The object to be encoded.
    /// - Returns: The encoded data or `nil` if the encoding process fails.
    /// - Throws: An error if there is an issue with encoding the object.
    func encode<T: Encodable>(object: T) throws -> Data? {
        // Try to encode the provided object into Data.
      guard let encodedData = try? JSONEncoder().encode(object) else {
          throw StoreError.encodeFailed
        
      }
      return encodedData
    }
}
