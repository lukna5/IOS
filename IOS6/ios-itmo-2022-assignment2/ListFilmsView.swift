//
//  ViewController.swift
//  ios-itmo-2022-assignment2
//
//  Created by rv.aleksandrov on 29.09.2022.
//

import UIKit
import OrderedCollections
import SwiftUI

class ListFilmsView: UIViewController {
    @IBOutlet private var tableView: UITableView!
    var countInSection = Dictionary<Date, Int>()
    let dateForm = DateFormatter()
    var sections: [Date] = []
    var films: [Film] = []
    @IBAction func buttonOnPress(_ sender: UIButton){
        print(7777)
        
        //let imageView = UIStoryboard(name: "ImageViewController", bundle: nil).instantiateInitialViewController()!
        //self.navigationController?.pushViewController(imageView, animated: true)
    }
    
    @IBAction
    private func addNewFilm(_ sender: UIButton){
        let SaveFilmView = SaveFilmView()
        SaveFilmView.delegate = self
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Array")?.withRenderingMode(.alwaysOriginal)
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Array")?.withRenderingMode(.alwaysOriginal)
        navigationItem.backButtonDisplayMode = .minimal
        self.navigationController?.pushViewController(SaveFilmView, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateForm.dateFormat = "dd.MM.yyyy"
        
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "Cell", bundle: nil), forCellReuseIdentifier: "Cell")

        // Do any additional setup after loading the view.
    }

    
}

class Film: Comparable{
    let year: Int
    let name: String
    let director: String
    let date: Date
    var rating: Int
    var imageName = ""
    init(name: String, director: String, date: Date, rating: Int) {
        self.name = name
        self.director = director
        self.date = date
        self.rating = rating
        self.year = Calendar.current.component(.year, from: date)
    }
    
    static func < (lhs: Film, rhs: Film) -> Bool {
        return lhs.date < rhs.date
    }
    
    static func == (lhs: Film, rhs: Film) -> Bool {
        return lhs.date == rhs.date
    }
    
    
}
extension ListFilmsView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countInSection[sections[section]]! // Change!!!!!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? Cell else {
            return UITableViewCell()
            
        }
        var index = 0
        var sectionNum = 0
        for i in sections{
            if sectionNum >= indexPath.section {
                break
            }
            index += countInSection[i] ?? 0
            sectionNum += 1
        }
        index += indexPath.row
        cell.setup(with: films[index])
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Удалить") {
            action, view, completion in
            var count = 0
            for i in 0..<indexPath.section {
                count += self.countInSection[self.sections[i]] ?? 0
            }
            var deleteSection = false
            if self.countInSection[self.sections[indexPath.section]] ?? 0 == 1{
                self.countInSection[self.sections[indexPath.section]] = 0
                self.sections.remove(at: indexPath.section)
                deleteSection = true
            } else {
                self.countInSection[self.sections[indexPath.section]] = (self.countInSection[self.sections[indexPath.section]] ?? 1) - 1
            }
            
            self.films.remove(at: count + indexPath.row)
            tableView.performBatchUpdates({
                tableView.deleteRows(at: [indexPath], with: .none)
                if deleteSection{
                    tableView.deleteSections(IndexSet(integer: indexPath.section), with: .none)
                }
            }, completion: nil)
            
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
        
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dateForm.string(from: sections[section])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var index = 0
        var sectionNum = 0
        for i in sections{
            if sectionNum >= indexPath.section {
                break
            }
            index += countInSection[i] ?? 0
            sectionNum += 1
        }
        index += indexPath.row
        let film = films[index]
        let host = UIHostingController(rootView: FIlmCard(film.name, film.director, film.rating, film.imageName))
        navigationController?.pushViewController(host, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return films.map({ String($0.year) })
    }
}

protocol CellDelegate: ListFilmsView {
    //func deleteFilm(film: Film)
}

extension ListFilmsView: CellDelegate{
    
    private func indexEqualFilm(film: Film) -> Int{
        for i in 0..<films.count{
            if films[i] == film {
                return i
            }
        }
        return sections.count
                
    }
    
    private func indexFirstBiggerOrEqual(date: Date) -> Int{
        for i in 0..<sections.count{
            if sections[i] >= date {
                return i
            }
        }
        return sections.count
                
    }
}
protocol SaveFilmViewDelegate: ListFilmsView {
    func addFilm(film: Film)
}

extension ListFilmsView: SaveFilmViewDelegate {
    func addFilm(film: Film) {
        let insertSectionIndex = indexFirstBiggerOrEqual(date: film.date)
        let rowsInSection = countInSection[film.date] ?? 0
        countInSection[film.date] = rowsInSection + 1
        if films.count == 0 || films[films.count - 1].date <= film.date {
            films.append(film)
        }
        else {
            for i in 0..<films.count {
                if films[i].date > film.date {
                    films.insert(film, at: i)
                    break
                }
            }
        }
        var needInsertSection = false
        if !sections.contains(film.date){
            needInsertSection = true
            sections.insert(film.date, at: insertSectionIndex)
        }
        
        tableView.performBatchUpdates({
            if needInsertSection{
                tableView.insertSections(IndexSet(integer: insertSectionIndex), with: .none)
            }
            tableView.insertRows(at: [IndexPath(row: rowsInSection, section: insertSectionIndex)], with: .none)
        }, completion: nil)
        

    }
    
    private func indexEqualDateFilm(film: Film) -> Int{
        for i in 0..<films.count{
            if films[i].date == film.date {
                return i
            }
        }
        return sections.count
                
    }
    

}
