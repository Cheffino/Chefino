//
//  LoadingView.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 20.06.2024.
//

import Foundation
import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            LottieView(url: URL(string: "https://lottie.host/7487b765-306d-4a14-9f49-50aff4edf455/UQjPybaJC0.json")!)
                .frame(width: 100, height: 100)
                .padding()
            
            Text("Loading...")
                .font(.headline)
                .padding()
        }
        .navigationTitle("Loading")
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
