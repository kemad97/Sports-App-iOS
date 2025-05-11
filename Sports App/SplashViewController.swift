//
//  SplashViewController.swift
//  SportsApp
//
//  Created by Kerolos on 10/05/2025.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    
    private var animationView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimation()
    }
    
    private func setupAnimation() {
        // Set background to match launch screen
        view.backgroundColor = .white // or whatever color your launch screen uses
        
        // Create animation view
        animationView = LottieAnimationView(name: "lottie")
        guard let animationView = animationView else { return }
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 250),
            animationView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        // Start the animation
                animationView.play()
                
                // Set the desired splash screen duration (e.g., 3 seconds)
        let splashScreenDuration: TimeInterval = 1//2.5
                DispatchQueue.main.asyncAfter(deadline: .now() + splashScreenDuration) { [weak self] in
                    self?.navigateToMainApp()
                }
        

    }
    
    private func navigateToMainApp() {
        let mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
        
        mainViewController.modalPresentationStyle = .fullScreen
        mainViewController.modalTransitionStyle = .flipHorizontal
        
        // Present main view controller
        self.present(mainViewController, animated: true)
    }
}
    

