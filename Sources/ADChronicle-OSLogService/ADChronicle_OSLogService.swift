import Foundation
import ADChronicle
import ADChronicle_OSLogHelpers
import os

@available(iOS 12.0, *)
@available(OSX 10.14, *)
extension ADChronicle {
    public class OSLogService: ADLogServiceProtocol {
        public init() { }
        
        public func log(_ error: Error,
                        file: StaticString,
                        function: StaticString,
                        line: UInt) {
            let message = String(reflecting: error)
            log(message,
                userInfo: nil,
                logger: ADChronicle.logger(for: file),
                file: file,
                function: function,
                logType: .error)
        }
        
        public func log(_ message: String,
                        userInfo: CustomDebugStringConvertible?,
                        logLevel: OSLogType,
                        file: StaticString,
                        function: StaticString,
                        line: UInt) {
            log(message,
                userInfo: userInfo,
                logger: ADChronicle.logger(for: file),
                file: file,
                function: function,
                logType: logLevel)
        }
    }
}

@available(iOS 12.0, *)
@available(OSX 10.14, *)
extension ADChronicle.OSLogService {
    private func log(_ message: String,
                     userInfo: CustomDebugStringConvertible?,
                     logger: OSLog,
                     file: StaticString,
                     function: StaticString,
                     logType: OSLogType) {
        let message = message + "\n\n" + "[User Info]:" + "\n" + ADChronicle.string(from: userInfo)
        
        os_log(logType,
               log: logger,
               "%{public}@\n%{public}@", function.description, message)
    }
}
