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
                logType: .error,
                signpostType: .event)
        }
        
        public func log(_ message: String,
                        userInfo: CustomDebugStringConvertible?,
                        logType: OSLogType,
                        signpostType: OSSignpostType,
                        file: StaticString,
                        function: StaticString,
                        line: UInt) {
            log(message,
                userInfo: userInfo,
                logger: ADChronicle.logger(for: file),
                file: file,
                function: function,
                logType: logType,
                signpostType: signpostType)
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
                     logType: OSLogType,
                     signpostType: OSSignpostType) {
        let message = message + "\n\n" + "[User Info]:" + "\n" + ADChronicle.string(from: userInfo)
        
        let staticName: StaticString = function
        let name = staticName.description
        
        os_log(logType,
               log: logger,
               "%{public}@\n%{public}@", name, message)
        
        os_signpost(signpostType,
                    log: logger,
                    name: staticName,
                    "%{public}@", message)
    }
}
