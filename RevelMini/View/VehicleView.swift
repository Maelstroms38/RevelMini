//
//  VehicleView.swift
//  RevelMini
//
//  Created by Michael Stromer on 2/19/20.
//  Copyright © 2020 Michael Stromer. All rights reserved.
//

import Foundation
import UIKit

public class VehicleView: UIView {
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Welcome!"
        return titleLabel
    }()
    lazy var statusLabel: UILabel = {
        let statusLabel = UILabel(frame: .zero)
        statusLabel.textAlignment = .center
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.text = "Select your ride to begin."
        return statusLabel
    }()
    lazy var greenButton: UIButton = {
        let greenButton = UIButton(frame: .zero)
        greenButton.isHidden = true
        greenButton.translatesAutoresizingMaskIntoConstraints = false
        greenButton.backgroundColor = .green
        greenButton.layer.cornerRadius = 15
        return greenButton
    }()
    lazy var blueButton: UIButton = {
        let blueButton = UIButton(frame: .zero)
        blueButton.isHidden = true
        blueButton.translatesAutoresizingMaskIntoConstraints = false
        blueButton.backgroundColor = .blue
        blueButton.layer.cornerRadius = 15
        return blueButton
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = true
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(statusLabel)
        stackView.addArrangedSubview(greenButton)
        stackView.addArrangedSubview(blueButton)
        return stackView
    }()
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubview(stackView)
        
        self.backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

