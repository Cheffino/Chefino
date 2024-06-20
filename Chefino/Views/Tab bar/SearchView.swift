//
//  SearchView.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 8.06.2024.
//
import SwiftUI

struct SearchView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false

    var body: some View {
        VStack {
            TextField("Search", text: $speechRecognizer.transcript)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .shadow(color: .gray, radius: 3, x: 0, y: 2)
                .padding(.horizontal)
            
            Button(action: {
                if self.isRecording {
                    self.speechRecognizer.stopTranscribing()
                } else {
                    self.speechRecognizer.startTranscribing()
                }
                self.isRecording.toggle()
            }) {
                Image(systemName: self.isRecording ? "mic.fill" : "mic.slash.fill")
                    .foregroundColor(.blue)
                    .imageScale(.large)
                    .padding()
            }
        }
        .padding()
        .navigationBarTitle("Search", displayMode: .inline)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
