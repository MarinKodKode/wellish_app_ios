//
//  CategoriesSectionView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marin on 21/09/25.
//

import SwiftUI

public struct  CategoriesSectionView :  View {
    
    let categories : [ActivityCategory] = ActivityCategory.allCases
            
        public var body : some View {
            VStack(alignment: .leading) {
               
                SectionBarTitle(title: "Categorias 💪🏻")
                    .padding(.horizontal)
               
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 16){
                        ForEach(categories , id: \.self){ category in
                            CategorieCard(category: category)
                        }
                    }
                    .padding(.horizontal)
                }
                
            }
        }
}

public struct CategorieCard : View {
    
    let category : ActivityCategory
        
    public var body  : some View {
        VStack(spacing: 8){
            HStack(alignment: .center){
                Text(category.rawValue) // title
                    .font(.system(size: 28))
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.leading, 16)
            
            HStack(alignment: .center, spacing: 20){
                VStack(alignment: .leading) {
                    HStack{
                        Text("4.9") // rating metric
                            .font(.system(size: 14))
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 14, height: 14)
                    }
                    Text("12 routines") // routines / exercises
                        .font(.system(size: 12))
                }
                Image(systemName: category.defaultIcon) // icon
                    .resizable()
                    .frame(width: 52, height: 52)
            }
        }
        .frame(width: UIScreen.screenWidth * 0.45, height: 160)
        .background(
            LinearGradient
                .customGradient(
                    baseColor: category.defaultColor,
                    direction: .bottomLeadingToTopTrailing
                )
        )
        .cornerRadius(16)
        .contentShape(Rectangle()) // AÑADE ESTO
    }
}


#Preview {
    CategoriesSectionView()
}
