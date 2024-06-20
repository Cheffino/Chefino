//
//  ErrorView.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 20.06.2024.
//

import Foundation
import SwiftUI

struct ErrorView: View {
    var body: some View {
        VStack {
            LottieView(url: URL(string: "https://lottie.host/65335c80-caef-4458-b8b2-872617658e26/RTbrCaNACQ.json")!)
                .frame(width: 400, height: 400)
                .padding()
            
            Text("An Error Occurred")
                .font(.title)
                .padding()
            
            // Hata detayları ve çözüm önerileri
        }
        .navigationTitle("Error")
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
