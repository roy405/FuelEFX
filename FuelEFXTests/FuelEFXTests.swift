//
//  FuelEFXTests.swift
//  FuelEFXTests
//
//  Created by Cube on 9/7/23.
//

@testable import FuelEFX
import XCTest

final class FuelEFXTests: XCTestCase {
    
    var fuelStore: FuelStore!
    var tripStore: TripStore!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        //Initialize the FuelStore before each test
        fuelStore = FuelStore()
        tripStore = TripStore()
    }
    
    override func tearDownWithError() throws {
        fuelStore = nil
        tripStore = nil
        try super.tearDownWithError()
    }
    
    //Json read and load test
    
    // Function to test loading records from file
    func testLoadRecordsFromFile() throws {
        do{
            try fuelStore.loadRecords()
            XCTAssertFalse(fuelStore.records.isEmpty, "Records should have been loaded from FuelRecords.json")
            
            try tripStore.loadRecords()
            XCTAssertFalse(tripStore.records.isEmpty, "Records should have been loaded from TripRecords.json")
        } catch {
            XCTFail("Error occured while loading records: \(error.localizedDescription)")
        }
    }
    
    
    // Testing valid inputs
    func testValidInput_AllFieldsFilled() {
        let result = tripStore.isValidInput(startOdometer: "100", endOdometer: "200", startLocation: "LocationA", endLocation: "LocationB", purpose: "Test")
        XCTAssertTrue(result.0, "Expected input to be valid")
    }
    
    // Testing Empty fields case
    func testValidInput_EmptyFields() {
        let result = tripStore.isValidInput(startOdometer: "", endOdometer: "200", startLocation: "LocationA", endLocation: "", purpose: "Test")
        XCTAssertFalse(result.0, "Expected input to be invalid")
        XCTAssertEqual(result.title, "Validation Error")
        XCTAssertEqual(result.message, "All fields are required. Please fill them out before saving.")
    }
    
    // Testing case where if the odometer reading entry is invalid chracters (not numerals)
    func testValidInput_InvalidOdometerReading() {
        let result = tripStore.isValidInput(startOdometer: "not_a_number", endOdometer: "200", startLocation: "LocationA", endLocation: "LocationB", purpose: "Test")
        XCTAssertFalse(result.0, "Expected input to be invalid")
        XCTAssertEqual(result.title, "Input Error")
        XCTAssertEqual(result.message, "Start and End Odometer readings must be valid numbers.")
    }
    
    // Testing saving if invalid inputs are passed
    func testSaveTripEntry_ValidInput() {
        let date = Date()
        let result = tripStore.saveTripEntry(date: date, startOdometer: "100", endOdometer: "200", startLocation: "LocationA", endLocation: "LocationB", purpose: "Test", notes: "Notes")
        XCTAssertTrue(result.0, "Expected saving to be successful")
        XCTAssertEqual(result.title, "Success")
        XCTAssertEqual(result.message, "Trip entry has been saved successfully.")
        
        // Optionally, validate that the new entry exists in the 'records'
        let lastEntry = tripStore.records.last
        XCTAssertEqual(lastEntry?.startOdometer, 100)
        XCTAssertEqual(lastEntry?.endOdometer, 200)
        // ... further validations ...
    }
    
    // Testing save if invalid odometer input
    func testSaveTripEntry_InvalidOdometerReading() {
        let date = Date()
        let result = tripStore.saveTripEntry(date: date, startOdometer: "not_a_number", endOdometer: "200", startLocation: "LocationA", endLocation: "LocationB", purpose: "Test", notes: "Notes")
        XCTAssertFalse(result.0, "Expected saving to be unsuccessful")
        XCTAssertEqual(result.title, "Input Error")
        XCTAssertEqual(result.message, "Start and End Odometer readings must be valid numbers.")
    }
    
    /// Trip Form Tests
    
    // Testing valid inputs
    func testValidInput() {
        let validation = fuelStore.isValidInput(odometerReading: "12345", fuelAmount: "50", fuelCost: "70", fuelType: "Diesel", location: "Station A")
        XCTAssertTrue(validation.0)
        XCTAssertEqual(validation.title, "Success")
        XCTAssertEqual(validation.message, "Input is valid.")
    }
    
    // Testing Empty fields case
    func testEmptyFieldsValidation() {
        let validation = fuelStore.isValidInput(odometerReading: "", fuelAmount: "", fuelCost: "", fuelType: "", location: "")
        XCTAssertFalse(validation.0)
        XCTAssertEqual(validation.title, "Validation Error")
        XCTAssertEqual(validation.message, "All fields are required. Please fill them out before saving.")
    }
    
    // Testing Cases where other characters are entered but numbers are expected
    func testInvalidNumberInput() {
        let validation = fuelStore.isValidInput(odometerReading: "abc", fuelAmount: "def", fuelCost: "ghi", fuelType: "Diesel", location: "Station A")
        XCTAssertFalse(validation.0)
        XCTAssertEqual(validation.title, "Input Error")
        XCTAssertEqual(validation.message, "Odometer reading, fuel amount, and fuel cost must be valid numbers.")
    }
    
    // Testing Validity of fuel entry information
    func testSavingValidFuelEntry() {
        let saveResult = fuelStore.saveFuelEntry(date: Date(), odometerReading: "12345", fuelAmount: "50", fuelCost: "70", fuelType: "Diesel", location: "Station A", notes: "Test Note")
        XCTAssertTrue(saveResult.0)
        XCTAssertEqual(saveResult.title, "Success")
        XCTAssertEqual(saveResult.message, "Fuel entry has been saved successfully.")
        XCTAssertEqual(fuelStore.records.last?.odometerReading, 12345)
    }
    
    // Testing saving a fuel entry
    func testSavingInvalidFuelEntry() {
        let saveResult = fuelStore.saveFuelEntry(date: Date(), odometerReading: "abc", fuelAmount: "def", fuelCost: "ghi", fuelType: "Diesel", location: "Station A", notes: "Test Note")
        XCTAssertFalse(saveResult.0)
        XCTAssertEqual(saveResult.title, "Input Error")
        XCTAssertEqual(saveResult.message, "Start and End Odometer readings must be valid numbers.")
    }
    
    // Testing updating a fuel record
    func testUpdateFuelRecord() throws {
        // Given: An existing fuel record
        let originalFuel = Fuel(id: 1, refillDate: "2023-09-07", odometerReading: 100.0, fuelAmount: 10.0, fuelCost: 50.0, fuelType: "Gasoline", refillLocation: "Station A", notes: "Test note")
        fuelStore.records.append(originalFuel)
        
        // When: Updating the fuel record
        let updatedDate = "2023-09-08"
        _ = fuelStore.saveEditedFuelChanges(fuel: originalFuel, refillDate: updatedDate, odometerReading: "105.0", fuelAmount: "10.5", fuelCost: "52.0", fuelType: "Diesel", refillLocation: "Station B", notes: "Updated test note")
        
        // Then: The fuel record should be updated
        guard let updatedFuel = fuelStore.records.first(where: { $0.id == originalFuel.id }) else {
            XCTFail("Fuel record not found!")
            return
        }
        XCTAssertEqual(updatedFuel.refillDate, updatedDate, "Fuel record update failed!")
    }
    
    // Testing updating a trip record
    func testUpdateTripRecord() throws {
        //Given: An exisiting trip record
        let originalTrip = Trip(id: 1, tripDate: "2023-09-07", startOdometer: 101000.0, endOdometer: 101010.0, startLocation: "Point A", endLocation: "Point B", purpose: "Commute", notes: "Test Note")
        tripStore.records.append(originalTrip)
        
        // When: Updating the trip record
        let updatedTripDate = "2023-09-09"
        _ = tripStore.saveEditedTripChanges(trip: originalTrip, tripDate: updatedTripDate, startOdometer: "102000.0", endOdometer: "102020.0", startLocation: "City", endLocation: "Home", purpose: "Work", notes: "Updated Trip Test Note")
        
        //Then: Then trip record should be updated
        guard let updatedTrip = tripStore.records.first(where: {$0.id == originalTrip.id}) else {
            XCTFail("Trip record not found!")
            return
        }
        XCTAssertEqual(updatedTrip.tripDate, updatedTripDate, "Trip record update failed!")
    }

}
