//
//  SplashScreen.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 20.06.2024.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        VStack {
            LottieView(url: URL(string: "https://lottie.host/e5fb33dd-e900-409c-867b-38e245832133/eKRipp8UwT.json")!)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .background(Color.white)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
