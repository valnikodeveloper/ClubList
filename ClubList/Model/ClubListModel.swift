//
//  ClubListModel.swift
//  ClubList
//
//  Created by Valeriy Nikolaev on 19/06/2019.
//  Copyright © 2019 Valeriy Nikolaev. All rights reserved.
//

import UIKit

//Clubs data
struct ClubListData:Decodable {
    var name:String?
    var description:String?
    var id:String?
}

class ClubListModel: NSObject {
    
    weak var delegate:ClubListModelDelegate?
    
    func requestInfoFromSite(urlStr:String, isDetailRequest:Bool) {
        let url = URL(string:urlStr)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: url!) { [weak self] (data, response, error) in
            
            if let err = error {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.displayError(error: err.localizedDescription)
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.displayError(error: "Не удалось получить данные с сервера.\n")
                }
                return
            }
            do {
                let jsonResponse = try JSONDecoder().decode([ClubListData].self, from: data)
                for club in (jsonResponse) {
                    var clubId = club.id
                    if clubId  == nil {
                        clubId  = "nil"
                    }
                    var name = club.name
                    if name == nil {
                        name = "NO NAME"
                    }
                    if isDetailRequest == false {
                        DispatchQueue.main.async { [weak self] in
                            self?.delegate?.insertNewRowInView?(newName: name!, clubId: clubId!)
                        }
                    } else {
                        var description = club.description
                        if description == nil {
                            description = "NO DESRIPTION"
                        }
                        
                        DispatchQueue.main.async { [weak self] in
                            //Send data to view
                            self?.delegate?.createFullDescr?(newName: name!, clubDescr: description!)
                        }
                    }

                }
            }catch let error {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.displayError(error: "Неудалось разобрать данные с сервера.\n====\nПодробности: \(error)")
                }
            }
        }.resume()
    }
    
    

}

@objc protocol ClubListModelDelegate:class {
    @objc optional func insertNewRowInView(newName: String, clubId: String)
    @objc optional func createFullDescr(newName: String, clubDescr: String)
    @objc func displayError(error: String)
}
