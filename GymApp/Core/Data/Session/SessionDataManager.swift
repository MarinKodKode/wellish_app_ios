//
//  SessionDataManager.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 25/11/25.
//

import SwiftUI
import Combine

final class SessionDataManager : ObservableObject {
    
    static let shared = SessionDataManager()
    
    private init(){}
    
    @AppStorage(SessionStorageKeys.clientFullName)
    var clientFullname : String = ""
    
    @AppStorage(SessionStorageKeys.clientEmail)
    var clientEmail: String = ""
    
    @AppStorage(SessionStorageKeys.photoURL)
    var photoURLString: String = ""
    
    @AppStorage(SessionStorageKeys.photoIdentifier)
    var photoIdentifier: String = "ffc4eef2-8db1-4a6f-a7fe-7bb02c36589b"
    
    @AppStorage(SessionStorageKeys.userId)
    var userId : String = ""
    
    var photoURL : URL? {
        URL(string: photoURLString)
    }
}
