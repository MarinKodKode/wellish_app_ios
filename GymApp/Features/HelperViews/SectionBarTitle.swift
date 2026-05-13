//
//  SectionBarTitle.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marin on 20/09/25.
//

import SwiftUI

public struct SectionBarTitle : View {
    
    let title : String
    let icon : String?
    
    init(title: String, icon: String? = nil) {
        self.title = title
        self.icon = icon
    }
    
    init(_ title : String ){
        self.title = title
        self.icon = nil
    }
    
    public var body : some View{
        HStack{
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.fitnessTextPrimary)
                .padding(.horizontal)
            Spacer()
            
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(.fitnessTextPrimary)
                    .padding(.trailing)
            }
        }
    }
}

#Preview {
    SectionBarTitle(title : StringConstants.challengesOfTheWeek, icon : "flame")
}
