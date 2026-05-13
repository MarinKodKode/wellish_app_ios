//
//  AddTagsWidget.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 30/10/25.
//

import SwiftUI

struct AddTagsWidget: View {
    
    let widget = WidgetHelpers()
    
    @Binding var newTagText : String
    @Binding var category : String
    @Binding var tagsArray : [String]
    
    var body: some View {
        widget.enhancedSectionView(
            title: StringConstants.routineTagsAndCategories,
            icon: "tag.fill",
            iconColor: .premiumFitnessPurple
        )  {
            VStack(spacing: 20) {
                HStack(spacing: 12) {
                    widget.customTextField(
                        placeholder: StringConstants.routineAddNewTag,
                        text: $newTagText,
                        icon: "plus",
                        iconColor: .premiumFitnessPurple
                    )
                    
                    Button(StringConstants.add) {
//                        vm.addTag(newTagText)
                        newTagText = ""
                    }
                    .disabled(newTagText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(newTagText.isEmpty ? Color.gray.opacity(0.3) : Color.premiumFitnessPurple)
                    .foregroundColor(.white)
                    .font(.subheadline.weight(.semibold))
                    .cornerRadius(12)
                }
                
                if !tagsArray.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(tagsArray, id: \.self) { tag in
                                EnhancedTagChip(tag: tag) {
                                    //vm.removeTag(tag)
                                }
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                }
                
                widget.customTextField(
                    placeholder: StringConstants.routineCategories,
                    text: $category,
                    icon: "square.grid.2x2",
                    iconColor: .fitnessTextSecondary
                )
            }
            
        }
    }
}
