//
//  Star.swift
//  ios-itmo-2022-assignment2
//
//  Created by mac on 22.12.2022.
//

import UIKit

class Star: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var starButton1: UIButton = {
        let button = UIButton.init(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("DO IT", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 7
        button.backgroundColor = .systemBrown
        //button.addTarget(self, action: #selector(didTouchButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var starButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tag = 1
        //button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.setImage(UIImage(named: "Star.png"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    func setupView(){
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(starButton)
        NSLayoutConstraint.activate([
            //header.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            //header.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
           // header.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            starButton.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            starButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            starButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
}
