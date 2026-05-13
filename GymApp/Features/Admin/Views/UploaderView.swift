//
//  Uploader.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 27/10/25.
//

import SwiftUI

struct AdminConsole : View {
    
    @ObservedObject var vm = UploaderViewModel()
    
    var body: some View {
        NavigationView {
            VStack() {
                VStack(alignment : .leading) {
                    Text("Exercise section")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.top, 32)
                    
                    Button(action: {
                        Task {
                            await vm.uploadGymExercises()
                        }
                    }, label: {
                        Text("Upload list of exercises")
                            .fontWeight(.semibold)
                            .padding(16)
                            .foregroundStyle(Color.white)
                            
                    })
                    .background(Color.black)
                    .cornerRadius(28)
                    
                    Spacer()
                }
                .frame(width: 377, alignment: .leading)
                .navigationTitle("Admin Console")
                .navigationBarTitleDisplayMode(.large)
            }
        }
    }
}


#Preview {
    AdminConsole()
}
