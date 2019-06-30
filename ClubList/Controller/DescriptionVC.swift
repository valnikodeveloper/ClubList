//
//  DescriptionVC.swift
//  ClubList
//
//  Created by Valeriy Nikolaev on 19/06/2019.
//  Copyright © 2019 Valeriy Nikolaev. All rights reserved.
//

import UIKit

class DescriptionVC: UIViewController {

    private var titleLabel = UILabel()
    private var descrLabel = UILabel()
    private var refreshItem = UIBarButtonItem()
    private var scrollView = UIScrollView()
    var clubListModel:ClubListModel!
    var withIdStrURL:String = ""

    func displayError(error:String) {
        let alert = UIAlertController(title: "Ошибка!", message: error, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .destructive , handler: nil)
        alert.addAction(ok)
        self.present(alert,animated:true,completion:nil)
    }

    private func setupNavBarItemRefresh() {
        refreshItem = UIBarButtonItem(title: "Refresh", style: UIBarButtonItem.Style.plain, target: self, action: #selector(refreshVC))
        refreshItem.tintColor = .blue
        self.navigationItem.rightBarButtonItem = refreshItem
    }

    func performRequestWithUrl(urlStr:String) {
        clubListModel.requestInfoFromSite(urlStr: urlStr, clubDataRelCallBack: { [weak self] clubListData,error in
                if let anError = error {
                        self?.displayError(error:anError.descrition)
                    return
                }
                self?.titleLabel.text = clubListData!.name
                if let descr =  clubListData?.description {
                    self?.descrLabel.text = descr
                }else {
                    self?.descrLabel.text = "NO DESCRIPTION"
                }
        })
    }

    @objc func refreshVC() {
        titleLabel.text = ""
        descrLabel.text = ""
        performRequestWithUrl(urlStr:withIdStrURL)
    }

    private func setupConstraints() {
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor,constant:70).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant:0).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        descrLabel.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        descrLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 0).isActive = true
        descrLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: 0).isActive = true
        descrLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }

    func createFullDescr(newName: String, clubDescr: String) {
        titleLabel.text = newName
        descrLabel.text = clubDescr
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        descrLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.backgroundColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
        titleLabel.numberOfLines = 3
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.textAlignment = .center
        titleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        titleLabel.font =  titleLabel.font.withSize(25)
        descrLabel.font = descrLabel.font.withSize(20)
        descrLabel.numberOfLines = 0
        descrLabel.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        descrLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubview(titleLabel)
        scrollView.addSubview(descrLabel)
        view.addSubview(scrollView)
        setupConstraints()
        setupNavBarItemRefresh()
        performRequestWithUrl(urlStr: withIdStrURL)
    }

}

