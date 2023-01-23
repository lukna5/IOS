//
//  ViewController.swift
//  ios-itmo-2022-assignment2
//
//  Created by rv.aleksandrov on 29.09.2022.
//

import UIKit

class SaveFilmView: UIViewController {
    weak var delegate: SaveFilmViewDelegate?
    
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
        rating = sender.tag
        if nameIsOk && directorIsOk && dateIsOk && starsView.isComplete{
            activeSave(active: true)
        } else {
            activeSave(active: false)
        }
    }
    
    private var nameFilm = "None"
    private var nameDirector = "None"
    private var year: Date?
    private var rating = 0
    
    @objc func changeText(_ sender: UITextField){
        let text = sender.text ?? ""
        switch sender.layer.name {
        case "Name":
            if text.count > 0 && text.count <= 300 {
                nameIsOk = true
                nameView.valideField()
            } else {
                nameView.unvalideField()
                nameIsOk = false
            }
            nameFilm = text
        case "Director":
            if text.count > 2 && text.count <= 300 && text.range(of: regexDirector, options: .regularExpression, range: nil, locale: nil) != nil {
                directorIsOk = true
                directorView.valideField()
            } else {
                directorView.unvalideField()
                directorIsOk = false
            }
            nameDirector = text

        case "Year":
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "dd.MM.yyyy"
            if dateFormatterGet.date(from: sender.text ?? "") != nil {
                dateIsOk = true
                year = dateFormatterGet.date(from: text)!
                dateView.valideField()
            } else {
                dateIsOk = false
                year = nil
                dateView.unvalideField()
            }
        default:
            break
        }
        if nameIsOk && directorIsOk && dateIsOk && starsView.isComplete{
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
    
    private lazy var nameView : CategoryView = CategoryView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .film, fun: #selector(changeText), controller: self)
    
    private lazy var directorView : CategoryView = CategoryView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .director, fun: #selector(changeText), controller: self)
    
    private lazy var dateView : CategoryView = CategoryView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .year, fun: #selector(changeText), controller: self)
    
    private lazy var starsView: Stars = Stars(frame: CGRect(x: 0, y: 0, width: 0, height: 0), sel: #selector(changeButton), controller: self)
    
    private lazy var saveButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBackground
        button.isEnabled = false
        button.addTarget(self, action: #selector(saveResult), for: .touchUpInside)
        button.setImage(UIImage(named: "saveButton.jpg")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    @objc
    private func saveResult(_ sender: UIButton){
        guard year != nil else {
            return
        }
        let film = Film(name: nameFilm, director: nameDirector, date: year!, rating: rating)
        delegate?.addFilm(film: film)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        super.viewDidLoad()
        view.addSubview(header)
        view.addSubview(nameView)
        view.addSubview(directorView)
        view.addSubview(dateView)
        view.addSubview(starsView)
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            header.heightAnchor.constraint(equalToConstant: 70),
            
            nameView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 30),
            nameView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            nameView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            nameView.heightAnchor.constraint(equalToConstant: 80),
            
            directorView.topAnchor.constraint(equalTo: nameView.bottomAnchor, constant: 10),
            directorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            directorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            directorView.heightAnchor.constraint(equalToConstant: 80),

            dateView.topAnchor.constraint(equalTo: directorView.bottomAnchor, constant: 10),
            dateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            dateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            dateView.heightAnchor.constraint(equalToConstant: 80),
            
            starsView.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 30),
            starsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starsView.heightAnchor.constraint(equalToConstant: 80),
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // Do any additional setup after loading the view.
    }

}

