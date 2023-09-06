//
//  JsonBundle.swift
//  FuelEFX
//
//  Created by Cube on 9/3/23.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(filename: String, as type: T.Type) throws -> T {
      guard let url = self.url(forResource: filename, withExtension: nil) else {
          throw StoreError.nofilefound
      }
      guard let data = try? Data(contentsOf: url) else {
          throw StoreError.loadingFailed
      }
      guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
          throw StoreError.decodefailed
      }
      return decodedData
    }
      
    func encode<T: Encodable>(object: T) throws -> Data? {
      guard let encodedData = try? JSONEncoder().encode(object) else {
          throw StoreError.encodeFailed
        
      }
      return encodedData
    }
}
