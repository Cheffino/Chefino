//
//  ContactView.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 20.06.2024.
//

import Foundation
import SwiftUI

struct ContactView: View {
    var body: some View {
        VStack {
            LottieView(url: URL(string: "https://lottie.host/e5fb33dd-e900-409c-867b-38e245832133/eKRipp8UwT.json")!)
                .frame(width: 200, height: 200)
                .padding()
            
            Text("Contact Us")
                .font(.largeTitle)
                .padding()
            
            // İletişim formu veya bilgileri
        }
        .navigationTitle("Contact")
    }
}

struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView()
    }
}
