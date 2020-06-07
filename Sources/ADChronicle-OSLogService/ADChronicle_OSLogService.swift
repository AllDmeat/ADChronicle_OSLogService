import Foundation
import ADChronicle
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
                logger: logger(for: file),
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
                logger: logger(for: file),
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
        let message = message + "\n\n" + "[User Info]:" + "\n" + string(from: userInfo)
        
        os_log(logType,
               log: logger,
               "%{public}@\n%{public}@", function.description, message)
    }
}

// MARK: Stringifiers
@available(iOS 12.0, *)
@available(OSX 10.14, *)
extension ADChronicle.OSLogService {
    private func string(from json: [String: Any]) -> String {
        guard JSONSerialization.isValidJSONObject(json),
            let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
            let jsonString = String(data: jsonData, encoding: .utf8)
            else { return String(describing: json) }
        
        return jsonString
    }
    
    private func string(from userInfo: CustomDebugStringConvertible?) -> String {
        if let json = userInfo as? [String: Any] {
            return string(from: json)
        }
        return String(describing: userInfo)
    }
}

// MARK: Loggers
@available(iOS 12.0, *)
@available(OSX 10.14, *)
extension ADChronicle.OSLogService {
    private func filename(from file: StaticString) -> String {
        return URL(fileURLWithPath: file.description).deletingPathExtension().lastPathComponent
    }
    
    private func logger(for file: StaticString) -> OSLog {
        return logger(subsystem: Bundle.main.bundleIdentifier!, file: file)
    }
    
    private func logger(subsystem: String, file: StaticString) -> OSLog {
        return OSLog(subsystem: subsystem, category: filename(from: file))
    }
}
