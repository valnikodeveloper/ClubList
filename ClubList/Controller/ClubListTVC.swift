//
//  ClubListTVC.swift
//  ClubList
//
//  Created by Valeriy Nikolaev on 19/06/2019.
//  Copyright © 2019 Valeriy Nikolaev. All rights reserved.
//

import UIKit

//Clubs data
struct ClubListData {
    var name:String! = ""
    var descriptionOfClub:String! = ""
    var id:String! = ""
}

class ClubListTVC: UITableViewController,ClubListModelDelegate {
    
    var clublList:[ClubListData] = []
    var clubListModel:ClubListModel!
    let strForUrl = "http://megakohz.bget.ru/test.php"
    let idStrUrl = "http://megakohz.bget.ru/test.php?id="
    
    @objc func refresh() {
        clublList.removeAll()
        tableView.reloadData()
        clubListModel.requestInfoFromSite(urlStr: strForUrl, isDetailRequest: false)
        
    }
    
    func setupNavBarItemRefresh() {
        let refreshItem = UIBarButtonItem(title: "Refresh", style: UIBarButtonItem.Style.plain, target: self, action: #selector(refresh))
        refreshItem.tintColor = .blue
        self.navigationItem.rightBarButtonItem = refreshItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clubListModel.delegate = self
    }

    func displayError(error:String) {
        let alert = UIAlertController(title: "Ошибка!", message: error, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .destructive , handler: nil)
        alert.addAction(ok)
        self.present(alert,animated:true,completion:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CellOfClub.self, forCellReuseIdentifier: "cellClubId")
        clubListModel = ClubListModel()
        clubListModel.requestInfoFromSite(urlStr: strForUrl, isDetailRequest: false)
        navigationItem.title = "ClubList"
        setupNavBarItemRefresh()
    }
    
    func insertNewRowInView(newName: String, clubId: String) {
        let club = ClubListData(name: newName, descriptionOfClub: "", id: clubId)
        tableView.beginUpdates()
        clublList.append(club)
        tableView.insertRows(at: [IndexPath(row: clublList.count - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return clublList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellClubId", for: indexPath)
        if indexPath.row < clublList.count {
            cell.textLabel?.text = clublList[indexPath.row].name
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let decrVC = DescriptionVC()
        decrVC.withIdStrURL = idStrUrl + clublList[indexPath.row].id
        decrVC.clubListModel = clubListModel
        clubListModel.delegate = decrVC
        clubListModel.requestInfoFromSite(urlStr: decrVC.withIdStrURL, isDetailRequest: true)
        navigationController?.pushViewController(decrVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
