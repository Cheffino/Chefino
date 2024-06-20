//
//  LottieView.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 20.06.2024.
//
import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var url: URL
    var loopMode: LottieLoopMode = .loop

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        let animationView = LottieAnimationView()
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        
        LottieAnimation.loadedFrom(url: url, closure: { animation in
            animationView.animation = animation
            animationView.play()
        }, animationCache: DefaultAnimationCache.sharedCache)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
   
