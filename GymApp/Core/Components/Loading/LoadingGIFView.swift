//
//  LoadingGIFView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 28/07/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct LoadingView: View {
    let deviceType = DeviceType(userInterfaceIdiom: UIDevice.current.userInterfaceIdiom)
    
    var body: some View {
        ZStack(alignment: .center) {
            
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
                .ignoresSafeArea()
            
            WebImage(url: gifURL())
                .resizable()
                .indicator(.activity)
                .scaledToFit()
                .frame(width: 80, height: 80, alignment: .center)
                .padding(.top, 20)
        }
        .ignoresSafeArea(.all)
        .ignoresSafeArea()
    }
    
    private func gifURL() -> URL? {
        return Bundle.main.url(forResource: "LoadingAnimation", withExtension: "gif")
    }
    
    private func calculateFrameWidth() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        
        if deviceType == .pad {
            return 100
        } else if deviceType == .phone {
            return screenWidth < 390 ? screenWidth - 250 : screenWidth - 320
        }
        
        return screenWidth * 0.8
    }
}

#Preview {
    LoadingView()
}
