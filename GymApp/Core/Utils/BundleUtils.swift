//
//  BundleUtils.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 28/07/25.
//

import Foundation
import UIKit

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    var releaseVersionNumberPretty: String {
        return "v\(releaseVersionNumber ?? "1.0.0")"
    }
}

enum DeviceType: String {
    case phone = "Phone"
    case pad = "Tablet"
    case tv = "Apple TV"
    case carPlay = "CarPlay"
    case mac = "Mac"
    case unknown = "Unknown"
    
    init(userInterfaceIdiom: UIUserInterfaceIdiom) {
        switch userInterfaceIdiom {
        case .unspecified:
            self = .unknown
        case .phone:
            self = .phone
        case .pad:
            self = .pad
        case .tv:
            self = .tv
        case .carPlay:
            self = .carPlay
        case .mac:
            self = .mac
        @unknown default:
            self = .unknown
        }
    }
}

func getDeviceModel() -> String? {
    var systemInfo = utsname()
    uname(&systemInfo)
    
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
        guard let value = element.value as? Int8, value != 0 else { return identifier }
        return identifier + String(UnicodeScalar(UInt8(value)))
    }
    
    if let deviceModelData = identifier.data(using: .utf8) {
        if let deviceModel = String(data: deviceModelData, encoding: .utf8)?.trimmingCharacters(in: .controlCharacters) {
            let modelName = deviceModel
            return modelName
        }
    }
    
    return nil
}
