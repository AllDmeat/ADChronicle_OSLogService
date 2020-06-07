import XCTest
import ADChronicle
import ADChronicle_OSLogService
@testable import ADChronicle_OSLogService

/// To see the results open up Console.app on macOS
/// And apply the Category filter "ADChronicle" in it's searchfield

@available(OSX 10.14, *)
@available(iOS 12.0, *)
final class ADChronicle_OSLogServiceTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        ADChronicle.configure(with: [ADChronicle.OSLogService()])
    }
    
    override func tearDownWithError() throws {
        ADChronicle.configure(with: [])
        
        try super.tearDownWithError()
    }
    
    func test_message() {
        ADChronicle.log("Simple message")
    }
    
    func test_messageWithUserInfo() {
        ADChronicle.log("Message with user info", userInfo: ["sender": self])
    }
    
    func test_messageWithJSONUserInfo() {
        let userInfo: [String: Any] = ["id": UUID().uuidString, "name": "Marty", "age": 21]
        let response = ["responseBody": userInfo]
        ADChronicle.log("Message with user info", userInfo: ["response": response])
    }
    
    func test_error() {
        ADChronicle.log(Error.someError)
    }
    
    func test_errorWithAssociatedValue() {
        ADChronicle.log(Error.errorWithAssociatedValue(value: "Some associated value, may be any type"))
    }
}

@available(OSX 10.14, *)
@available(iOS 12.0, *)
extension ADChronicle_OSLogServiceTests {
    enum Error: Swift.Error {
        case someError
        case errorWithAssociatedValue(value: String)
    }
}
