//
//  ClubListTVC.swift
//  ClubList
//
//  Created by Valeriy Nikolaev on 19/06/2019.
//  Copyright © 2019 Valeriy Nikolaev. All rights reserved.
//

import UIKit

class ClubListTVC: UITableViewController {
    
    private var clublList:[ClubListData] = []
    private var clubListModel:ClubListModel!
    private let strForUrl = "http://megakohz.bget.ru/test.php"
    private let idStrUrl = "http://megakohz.bget.ru/test.php?id="
    private func performRequestWithUrl(urlStr:String) {
        clubListModel.requestInfoFromSite(urlStr: urlStr, clubDataRelCallBack: { [weak self] clubData , error, jsonCount in
            if let anError = error  {
                    self?.displayError(error: anError.descrition)
                return
            }
            self?.insertNewRowInView(newName: clubData!.name!, clubId: clubData!.id!,count:jsonCount!)
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func endRefresh() {
        if refreshControl!.isRefreshing {
            refreshControl?.endRefreshing()
            refreshControl?.attributedTitle = NSAttributedString(string: "", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: UIFont.systemFontSize)])
        }else {
            tableView.backgroundView = nil
        }
    }

    func displayError(error:String) {
            let alert = UIAlertController(title: "Ошибка!", message: error, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .destructive , handler: { [weak self] _ in
                self?.endRefresh()
            })
            alert.addAction(ok)
            present(alert,animated:true,completion:nil)
    }

    func setupBackgroundLoading() {
        
        var navBarHeigh:CGFloat = 44
        
        if let height = navigationController?.navigationBar.frame.height {
            navBarHeigh = height
        }
        
        let stack = UIStackView(frame: view.frame)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        tableView.tableFooterView = UIView()
        tableView.backgroundView = stack
        let loadLabel = UILabel()
        loadLabel.text = "Loading..."
        loadLabel.sizeToFit()
        let activity = UIActivityIndicatorView(style: .gray)
        activity.startAnimating()
        stack.addArrangedSubview(loadLabel)
        stack.addArrangedSubview(activity)
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -navBarHeigh).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundLoading()
        setupRefreshBehavior()
        view.backgroundColor = .lightGray
        tableView.register(CellOfClub.self, forCellReuseIdentifier: "cellClubId")
        clubListModel = ClubListModel()
        let label = UILabel()
        label.text = "ClubList"
        navigationItem.titleView = label
        performRequestWithUrl(urlStr: strForUrl)
    }

    func setupRefreshBehavior () {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle =  NSAttributedString(string: "", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: UIFont.systemFontSize)])
        refreshControl?.addTarget(self, action:
            #selector(updating),for: .valueChanged)
    }
    
    @objc func updating() {
        refreshControl?.attributedTitle =  NSAttributedString(string: "Updating", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: UIFont.systemFontSize)])
        clublList.removeAll()
        tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .none)
        performRequestWithUrl(urlStr: strForUrl)
    }

    func insertNewRowInView(newName: String, clubId: String,count:Int) {
        let club = ClubListData(name: newName, description: nil, id: clubId)
        tableView.beginUpdates()
        clublList.append(club)
        tableView.insertRows(at: [IndexPath(row: clublList.count - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
        if count == tableView.numberOfRows(inSection: 0) {
            endRefresh()
        }
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
            if  tableView.backgroundView != nil {
                tableView.backgroundView = nil
            }
            cell.textLabel?.text = clublList[indexPath.row].name
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let decrVC = DescriptionVC()
        decrVC.withIdStrURL = idStrUrl + clublList[indexPath.row].id!
        decrVC.clubListModel = clubListModel
        navigationController?.pushViewController(decrVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
