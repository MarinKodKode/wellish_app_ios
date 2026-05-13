//
//  Profile_Section_QuickActions.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 16/12/25.
//

import SwiftUI


struct  Profile_Section_QuickActions :  View {
    
    @StateObject private var vm = ProfileViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.title3.bold())
                .foregroundColor(.fitnessTextPrimary)
            
            VStack(spacing: 12) {
                Profile_Component_ActionRow(icon: "person.circle", label: "Body Metrics", action: {})
                Profile_Component_ActionRow(
                    icon : "rectangle.portrait.and.arrow.forward",
                    label : "Cerrar sesión",
                    action: {
                        vm.onTap_CloseSession()
                    })
            }
        }
    }
}
