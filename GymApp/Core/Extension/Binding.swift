
import Foundation
import SwiftUI

extension Binding where Value == String? {
    func replacingNilWith(_ defaultValue: String) -> Binding<String> {
        Binding<String>(
            get: { self.wrappedValue ?? defaultValue },
            set: { self.wrappedValue = $0 }
        )
    }
    
    var withDefault: Binding<String> {
            Binding<String>(
                get: { self.wrappedValue ?? "" },
                set: { self.wrappedValue = $0.isEmpty ? nil : $0 }
            )
        }
}
