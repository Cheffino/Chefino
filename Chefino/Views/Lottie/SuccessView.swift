//
//  SuccessView.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 20.06.2024.
//

import Foundation
import SwiftUI

struct SuccessView: View {
    var body: some View {
        VStack {
            LottieView(url: URL(string: "https://lottie.host/02a3314a-ed47-4190-aa10-53872f30ebd7/ibgGavxHqy.json")!)
                .frame(width: 200, height: 200)
                .padding()
            
            Text("Operation Successful!")
                .font(.title)
                .padding()
        }
        .navigationTitle("Success")
    }
}

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessView()
    }
}
