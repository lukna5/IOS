//
//  CardView.swift
//  ios-itmo-2022-assignment2
//
//  Created by mac on 15.12.2022.
//

import UIKit

class CardView: UIView {
    override init(frame: CGRect) {
        print(frame)
        super.init(frame: frame)
        setupView()
    }
    init(frame: CGRect, text: String) {
        print(text)
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    private lazy var nameView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerName: UILabel = {
        let label = UILabel()
        label.text = "Название"
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 10.0)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var changeButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("DO IT", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 7
        button.backgroundColor = .systemBrown
        button.addTarget(self, action: #selector(didTouchButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var customLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Тут типо текст Тут типо текст Тут типо текст Тут типо текст "
        return label
    }()
    func configureView(title: String){
        customLabel.text = title
    }
    
    @objc
    private func didTouchButton(){
        customLabel.text = "New Text"
    }
    
    private func setupView() {
        backgroundColor = .red
        addSubview(containerView)
        containerView.addSubview(changeButton)
        containerView.addSubview(customLabel)
        NSLayoutConstraint.activate([
            changeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            changeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            changeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            customLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            customLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            customLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            customLabel.bottomAnchor.constraint(equalTo: topAnchor, constant: -20)
            

        ])
    }
}
