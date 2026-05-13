//
//  Badge.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 24/09/25.
//

import SwiftUI

struct Badge: View {
    
    let label : String
    var body: some View {
        HStack(){
            Text(label)
                .font(.system(size: 12))
                .fontWeight(.semibold)
                .padding(.vertical, 20)
                .padding(.horizontal, 15)
        }
        .frame(height: 28)
        .background(LinearGradient.homeWorkout)
        .cornerRadius(6)
        
    }
}

#Preview {
    Badge(label: "Intermediate")
}
