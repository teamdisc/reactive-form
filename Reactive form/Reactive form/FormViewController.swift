//
//  FormViewController.swift
//  Reactive form
//
//  Created by Pirush Prechathavanich on 6/24/17.
//  Copyright © 2017 Pirush Prechathavanich. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var loginTabButton: UIButton!
    @IBOutlet weak var registerTabButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        // cornerRadius buttons
        let loginMaskLayer = CAShapeLayer()
        let registerMaskLayer = CAShapeLayer()
        let buttonPath = UIBezierPath(roundedRect: loginTabButton.bounds,
                                      byRoundingCorners: [.topLeft, .topRight],
                                      cornerRadii: CGSize(width: 10, height: 10))
        loginMaskLayer.path = buttonPath.cgPath
        registerMaskLayer.path = buttonPath.cgPath
        loginTabButton.layer.mask = loginMaskLayer
        registerTabButton.layer.mask = registerMaskLayer
        
        // cornerRadius tableview
        let path = UIBezierPath(roundedRect: cardView.bounds,
                                byRoundingCorners: [.bottomLeft, .bottomRight],
                                cornerRadii: CGSize(width: 10, height: 10))
        cardView.layer.shadowRadius = 8
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowPath = path.cgPath
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        registerButton.layer.cornerRadius = registerButton.bounds.height/2
        registerButton.layer.borderWidth = 2
        registerButton.layer.borderColor = UIColor.white.cgColor
    }

}
