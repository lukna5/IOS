//
//  categoryView.swift
//  ios-itmo-2022-assignment2
//
//  Created by mac on 15.12.2022.
//

import UIKit
public enum typeCategory{
    case film, director, year
}
class CategoryView: UIView, UITextFieldDelegate{
var sel: Selector
    var controller: SaveFilmView
    init(frame: CGRect, type: typeCategory, fun: Selector, controller: SaveFilmView) {
        self.sel = fun
        self.controller = controller
        self.type = type
        super.init(frame: frame)
        setupView()
    }
    let type: typeCategory
    override var intrinsicContentSize: CGSize {
        let originalContentSize = super.intrinsicContentSize
        let height = originalContentSize.height + 12
        return CGSize(width: originalContentSize.width + 20, height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc
    public func setLabel(text: String){
        header.text = text
    }
    
    private lazy var header: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var fieldYear: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Год выпуска"
        field.borderStyle = .roundedRect
        field.layer.cornerRadius = 4
        field.addTarget(controller, action: sel, for: .allEditingEvents)
        field.inputView = datePicker
        let toolBar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([doneButton], animated: true)
        toolBar.sizeToFit()
        field.inputAccessoryView = toolBar
        return field
    }()
    
    @objc private func donePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.timeZone = .none
        
        self.fieldYear.text = dateFormatter.string(from: datePicker.date)
        fieldYear.endEditing(true)
        
    }
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        return datePicker
    }()
    
    public func valideField(){
        header.textColor = .darkGray
        stepsTextField.layer.borderWidth = 0.0
        stepsTextField.layer.borderColor = UIColor.systemGray6.cgColor
    }
    
    public func unvalideField(){
        header.textColor = .red
        stepsTextField.layer.borderWidth = 1.0
        stepsTextField.layer.borderColor = UIColor.red.cgColor
    }
    
    var stepsTextField = UITextField()
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        //backgroundColor = .systemPink
        addSubview(header)
        switch type{
        case .film, .director, .year:
            stepsTextField = UITextField()
            if type == .film{
                header.text = "Название"
                stepsTextField.layer.name = "Name"
                stepsTextField.placeholder = "Название фильма"
            }  else if type == .director {
                header.text = "Режиссёр"
                stepsTextField.layer.name = "Director"
                stepsTextField.placeholder = "Режиссёр фильма"
            } else {
                header.text = "Год"
                stepsTextField = fieldYear
                stepsTextField.placeholder = "Год"
                stepsTextField.layer.name = "Year"
            }
            
            stepsTextField.backgroundColor = .systemGray6
            stepsTextField.addTarget(controller, action: sel, for: .editingChanged)
            stepsTextField.translatesAutoresizingMaskIntoConstraints = false
            stepsTextField.borderStyle = .roundedRect
            addSubview(stepsTextField)
            NSLayoutConstraint.activate([
                header.topAnchor.constraint(equalTo: topAnchor, constant: 12),
                header.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
                header.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
                header.heightAnchor.constraint(equalToConstant: 15),
                
                stepsTextField.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10),
                stepsTextField.leadingAnchor.constraint(equalTo: header.leadingAnchor),
                stepsTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
                stepsTextField.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }
}
