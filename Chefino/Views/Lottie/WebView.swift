//
//  WebView.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 11.06.2024.
//
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        DispatchQueue.main.async {
            uiView.load(request)
        }
    }
}
