//
//  GeneralInfoWdget.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 30/10/25.
//

import SwiftUI

struct GeneralInfoWdget: View {
    
    let widget = WidgetHelpers()
    
    @Binding var name : String
    @Binding var description : String?
    
    var body: some View {
        widget.enhancedSectionView(
            title: StringConstants.routinedetailsTitle,
            icon: "dumbbell.fill",
            iconColor: .primaryFitnessBlue
        ) {
            VStack(spacing: 20) {
                widget.customTextField(
                    placeholder: StringConstants.routineName,
                    text: $name,
                    icon: "pencil",
                    iconColor: .primaryFitnessBlue
                )
                
                widget.customTextField(
                    placeholder: StringConstants.routineDescription,
                    text: $description.replacingNilWith(""),
                    icon: "text.alignleft",
                    iconColor: .fitnessTextSecondary
                )
            }
        }
    }
}
