//
//  ViewController.swift
//  ios-itmo-2022-assignment2
//
//  Created by rv.aleksandrov on 29.09.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var header: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Фильм"
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 35.0)
        return label
    }()
    
    private var nameIsOk = false
    private var directorIsOk = false
    private var dateIsOk = false
    private var regexDirector = "^([А-ЯA-Z]+[а-яa-z]*[ ]*)+$"
    
    @objc func changeButton(_ sender: UIButton){
        if nameIsOk && directorIsOk && dateIsOk && stars.isComplete{
            activeSave(active: true)
        } else {
            activeSave(active: false)
        }
    }
    
    @objc func changeText(_ sender: UITextField){
        let text = sender.text ?? ""
        switch sender.layer.name {
        case "Name":
            if text.count > 0 && text.count <= 300 {
                nameIsOk = true
                nameFilm.valideField()
            } else {
                nameFilm.unvalideField()
                nameIsOk = false
            }
        case "Director":
            if text.count > 2 && text.count <= 300 && text.range(of: regexDirector, options: .regularExpression, range: nil, locale: nil) != nil {
                directorIsOk = true
                nameDirector.valideField()
            } else {
                nameDirector.unvalideField()
                directorIsOk = false
            }
        case "Year":
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "dd.MM.yyyy"
            if dateFormatterGet.date(from: sender.text ?? "") != nil {
                dateIsOk = true
                dateFilm.valideField()
            } else {
                dateIsOk = false
                dateFilm.unvalideField()
            }
        default:
            break
        }
        if nameIsOk && directorIsOk && dateIsOk && stars.isComplete{
            activeSave(active: true)
        } else {
            activeSave(active: false)
        }
    }
    
    private var saveIsActive = false
    private func activeSave(active: Bool){
        if active && !saveIsActive {
            saveButton.setImage(UIImage(named: "okSave.png")?.withRenderingMode(.alwaysOriginal),
                                for: .normal)
            saveButton.isEnabled = true
            saveIsActive = true
        }
        else if !active && saveIsActive {
            saveButton.setImage(UIImage(named: "saveButton.jpg")?.withRenderingMode(.alwaysOriginal),
                                for: .normal)
            
            saveButton.isEnabled = false
            saveIsActive = false
        }
    }
    
    private lazy var nameFilm : CategoryView = CategoryView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .film, fun: #selector(changeText), controller: self)
    
    private lazy var nameDirector : CategoryView = CategoryView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .director, fun: #selector(changeText), controller: self)
    
    private lazy var dateFilm : CategoryView = CategoryView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .year, fun: #selector(changeText), controller: self)
    
    private lazy var stars: Stars = Stars(frame: CGRect(x: 0, y: 0, width: 0, height: 0), sel: #selector(changeButton), controller: self)
    
    private lazy var saveButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBackground
        button.isEnabled = false
        button.setImage(UIImage(named: "saveButton.jpg")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(header)
        view.addSubview(nameFilm)
        view.addSubview(nameDirector)
        view.addSubview(dateFilm)
        view.addSubview(stars)
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            header.heightAnchor.constraint(equalToConstant: 70),
            
            nameFilm.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 30),
            nameFilm.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            nameFilm.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            nameFilm.heightAnchor.constraint(equalToConstant: 80),
            
            nameDirector.topAnchor.constraint(equalTo: nameFilm.bottomAnchor, constant: 10),
            nameDirector.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            nameDirector.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            nameDirector.heightAnchor.constraint(equalToConstant: 80),

            dateFilm.topAnchor.constraint(equalTo: nameDirector.bottomAnchor, constant: 10),
            dateFilm.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            dateFilm.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            dateFilm.heightAnchor.constraint(equalToConstant: 80),
            
            stars.topAnchor.constraint(equalTo: dateFilm.bottomAnchor, constant: 30),
            stars.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stars.heightAnchor.constraint(equalToConstant: 80),
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // Do any additional setup after loading the view.
    }

}

