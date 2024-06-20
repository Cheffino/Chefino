//
//  SearchBar.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 11.06.2024.
//
import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false

    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)

                        if !text.isEmpty {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onChange(of: speechRecognizer.transcript) { newValue in
                    text = newValue
                }

            Button(action: {
                if self.isRecording {
                    self.speechRecognizer.stopTranscribing()
                } else {
                    self.speechRecognizer.startTranscribing()
                }
                self.isRecording.toggle()
            }) {
                Image(systemName: self.isRecording ? "mic.fill" : "mic")
                    .foregroundColor(.blue)
                    .imageScale(.large)
                    .padding(.trailing, 10)
            }
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""))
    }
}
