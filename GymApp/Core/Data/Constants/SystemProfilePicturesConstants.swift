//
//  SystemProfilePicturesConstants.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 28/11/25.
//

import Foundation
import SwiftUI

final class SystemImages {
    
    private let systemProfilePictureAssets : [String] = [
        "ffc4eef2-8db1-4a6f-a7fe-7bb02c36589b",
        "75ac4a89-6734-4b47-960d-f94fbc1dba96",
        "3b91f819-5523-4019-a720-cd239d9a32fd",
        "a36c2c5c-c65d-4682-801b-45053caca497",
        "20a69759-9582-44dd-ae1e-8be01a75d5c2",
        "b008477d-ed23-41d1-861a-f1c8e22db59a",
        "5535c7d3-8965-41f1-8f3c-b343ed127626",
        "7b813838-64b3-4424-90f3-5053266fb586",
        "87a0cfe3-f4fc-4141-861a-0a82d221b1a1",
        "5457b9a8-c73a-43fd-800a-ecc14af67af2",
        "d01bfa64-6c54-43d2-9d7f-c95c65e20421",
        "8aac6122-7f1b-4ebf-8de3-bc4df7945e87"
    ]
    
    public func getRandomProfilePicture() -> String {
        return systemProfilePictureAssets.randomElement() ?? ""
    }
    
    static let avatars : [(imageID : String, color : Color, label : String)] = [
        ("ffc4eef2-8db1-4a6f-a7fe-7bb02c36589b", Color(hex: "FF6B6B"), "Bison Power"),
        ("75ac4a89-6734-4b47-960d-f94fbc1dba96", Color(hex: "FFD700"), "Bull Testo"),
        ("3b91f819-5523-4019-a720-cd239d9a32fd", Color(hex: "10B981"), "Bear Fear"),
        ("a36c2c5c-c65d-4682-801b-45053caca497", Color(hex: "6F5FDF"), "Elephant"),
        ("20a69759-9582-44dd-ae1e-8be01a75d5c2", Color(hex: "FF69B4"), "Rino Punch"),
        ("b008477d-ed23-41d1-861a-f1c8e22db59a", Color(hex: "FF69B4"), "Heart"),
        ("5535c7d3-8965-41f1-8f3c-b343ed127626", Color(hex: "FF69B4"), "Heart"),
        ("7b813838-64b3-4424-90f3-5053266fb586", Color(hex: "FF69B4"), "Heart"),
        ("87a0cfe3-f4fc-4141-861a-0a82d221b1a1", Color(hex: "FF69B4"), "Heart"),
        ("5457b9a8-c73a-43fd-800a-ecc14af67af2", Color(hex: "FF69B4"), "Heart"),
        ("d01bfa64-6c54-43d2-9d7f-c95c65e20421", Color(hex: "FF69B4"), "Heart"),
        ("8aac6122-7f1b-4ebf-8de3-bc4df7945e87", Color(hex: "FF69B4"), "Heart"),
    ]
    
}
