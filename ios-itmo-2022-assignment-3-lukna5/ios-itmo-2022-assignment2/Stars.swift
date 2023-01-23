//
//  Stars.swift
//  ios-itmo-2022-assignment2
//
//  Created by mac on 18.01.2023.
//

import Foundation
import UIKit

class Stars: UIView{
    var sel: Selector
    var controller: SaveFilmView
    init(frame: CGRect, sel: Selector, controller: SaveFilmView) {
        self.sel = sel
        self.controller = controller
        super.init(frame: frame)
        setupView()
    }

    public var isComplete = false
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var star1: UIButton = {
        let button = UIButton(type: .custom)
        button.tag = 1
        button.setImage(UIImage(named: "Star.png"), for: .normal)
        button.addTarget(self, action: #selector(didTouchButton), for: .touchUpInside)
        button.addTarget(controller, action: sel, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var star2: UIButton = {
        let button = UIButton(type: .custom)
        button.tag = 2
        button.addTarget(self, action: #selector(didTouchButton), for: .touchUpInside)
        button.addTarget(controller, action: sel, for: .touchUpInside)
        button.setImage(UIImage(named: "Star.png"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var star3: UIButton = {
        let button = UIButton(type: .custom)
        button.tag = 3
        button.addTarget(self, action: #selector(didTouchButton), for: .touchUpInside)
        button.addTarget(controller, action: sel, for: .touchUpInside)
        button.setImage(UIImage(named: "Star.png"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var star4: UIButton = {
        let button = UIButton(type: .custom)
        button.tag = 4
        button.addTarget(self, action: #selector(didTouchButton), for: .touchUpInside)
        button.addTarget(controller, action: sel, for: .touchUpInside)
        button.setImage(UIImage(named: "Star.png"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var star5: UIButton = {
        let button = UIButton.init(type: .custom)
        button.tag = 5
        button.addTarget(self, action: #selector(didTouchButton), for: .touchUpInside)
        button.addTarget(controller, action: sel, for: .touchUpInside)
        button.setImage(UIImage(named: "Star.png"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var starArray = [star1, star2, star3, star4, star5]

    @objc
    private func didTouchButton(_ sender: UIButton){
        isComplete = true
        for i in 0...sender.tag-1{
            starArray[i].setImage(UIImage(named: "StarActive.png"), for: .normal)
        }
        for i in sender.tag..<5{
            starArray[i].setImage(UIImage(named: "Star.png"), for: .normal)
        }
        switch sender.tag{
        case 1: rating.text = "Ужасно"
        case 2: rating.text = "Плохо"
        case 3: rating.text = "Нормально"
        case 4: rating.text = "Хорошо"
        case 5: rating.text = "AMAZING!"

        default:
            //skip
            break
        }
    }
    
    private lazy var rating: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Ваша оценка"
        label.font = .systemFont(ofSize: 19)
        label.textColor = .lightGray
        return label
    }()
    
    private func setupView(){
        addSubview(star1)
        addSubview(star2)
        addSubview(star3)
        addSubview(star4)
        addSubview(star5)
        addSubview(rating)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            star1.topAnchor.constraint(equalTo: topAnchor),
            star1.bottomAnchor.constraint(equalTo: rating.topAnchor, constant: -10),
            star1.trailingAnchor.constraint(equalTo: star2.leadingAnchor, constant: -10),
            star1.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            star2.topAnchor.constraint(equalTo: topAnchor),
            star2.bottomAnchor.constraint(equalTo: rating.topAnchor, constant: -10),
            star2.trailingAnchor.constraint(equalTo: star3.leadingAnchor, constant: -10),
            
            star3.topAnchor.constraint(equalTo: topAnchor),
            star3.bottomAnchor.constraint(equalTo: rating.topAnchor, constant: -10),
            star3.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            star4.topAnchor.constraint(equalTo: topAnchor),
            star4.bottomAnchor.constraint(equalTo: rating.topAnchor, constant: -10),
            star4.leadingAnchor.constraint(equalTo: star3.trailingAnchor),
            
            star5.topAnchor.constraint(equalTo: topAnchor),
            star5.bottomAnchor.constraint(equalTo: rating.topAnchor, constant: -10),
            star5.leadingAnchor.constraint(equalTo: star4.trailingAnchor),
            star5.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            rating.centerXAnchor.constraint(equalTo: centerXAnchor),
            rating.bottomAnchor.constraint(equalTo: bottomAnchor),
            rating.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
