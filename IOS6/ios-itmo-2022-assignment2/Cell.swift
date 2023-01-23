//
//  Cell.swift
//  ios-itmo-2022-assignment2
//
//  Created by mac on 19.01.2023.
//

import UIKit

class Cell: UITableViewCell{
    @IBOutlet private var star1: UIButton!
    @IBOutlet private var star2: UIButton!
    @IBOutlet private var star3: UIButton!
    @IBOutlet private var star4: UIButton!
    @IBOutlet private var star5: UIButton!
    @IBOutlet private var filmName: UILabel!
    @IBOutlet private var directorName: UILabel!
    
    private lazy var starArray = [star1, star2, star3, star4, star5]
    private var film: Film? = nil    
    
    public func activateStars(count: Int){
        for i in 0..<count{
            starArray[i]!.setImage(UIImage(named: "StarActive.png"), for: .normal)
        }
        for i in count..<5{
            starArray[i]!.setImage(UIImage(named: "Star.png"), for: .normal)
        }
    }
    
    @IBAction
    func pressStar(_ sender: UIButton){
        film?.rating = sender.tag
        activateStars(count: sender.tag)
    }
    
    
    public func setup(with film: Film){
        self.film = film
        filmName.text = film.name
        activateStars(count: film.rating)
        filmName.numberOfLines = film.name.count / 3 + 1
        directorName.text = film.director

    }
}
