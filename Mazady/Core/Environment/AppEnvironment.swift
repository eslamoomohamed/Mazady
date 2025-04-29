//
//  AppEnvironment.swift
//  Mazady
//
//  Created by eslam mohamed on 29/04/2025.
//

import Foundation

struct AppEnvironment {

    enum Environment: String {
        case development
        case staging
        case production
    }

    enum Configuration {
        case debug
        case release
    }

    static let currentConfiguration: Configuration = {
        #if DEBUG
        return .debug
        #else
        return .release
        #endif
    }()

    static let currentEnvironment: Environment = {
        guard let environmentString = Bundle.main.infoDictionary?["Environment"] as? String else {
            fatalError("❌ 'Environment' key not found in Info.plist or .xcconfig.")
        }
        
        guard let environment = Environment(rawValue: environmentString.lowercased()) else {
            fatalError("Invalid Environment value: \(environmentString)")
        }
        
        return environment
    }()

    static var isDebug: Bool {
        currentConfiguration == .debug
    }

    static var isRelease: Bool {
        currentConfiguration == .release
    }

    static var isDevelopment: Bool {
        currentEnvironment == .development
    }

    static var isStaging: Bool {
        currentEnvironment == .staging
    }

    static var isProduction: Bool {
        currentEnvironment == .production
    }

    static func printCurrentEnvironment() {
        print("""
        App Started with:
        - Environment: \(currentEnvironment)
        - Configuration: \(currentConfiguration)
        """)
    }
}
