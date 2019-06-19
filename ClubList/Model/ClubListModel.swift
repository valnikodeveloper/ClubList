//
//  ClubListModel.swift
//  ClubList
//
//  Created by Valeriy Nikolaev on 19/06/2019.
//  Copyright © 2019 Valeriy Nikolaev. All rights reserved.
//

import UIKit

class ClubListModel: NSObject {
    
    weak var delegate:ClubListModelDelegate?
    
    func requestInfoFromSite(urlStr:String, isDetailRequest:Bool) {
        //MARK: ATTENTION ! URL should be here:
        let url = URL(string:urlStr)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: url!) { [weak self] (data, response, error) in
            guard let data = data else {
                self?.delegate?.displayError(error: "Не удалось получить данные с сервера.\n")
                return
            }
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                
                guard let jsonDic = jsonResponse as? [[String: Any]] else {
                    DispatchQueue.main.async {
                        self?.delegate?.displayError(error: "Не удалось разобрать полученные данные. \n")
                    }
                    return
                }

                for club in (jsonDic) {
                    
                    var clubId = club["id"] as? String
                    if clubId  == nil {
                        clubId  = "nil"
                    }
                    var name = club["name"] as? String
                    if name == nil {
                        name = "NO NAME"
                    }
                    if isDetailRequest == false {
                        DispatchQueue.main.async { [weak self] in
                            //Send data to view
                            self?.delegate?.insertNewRowInView?(newName: name!, clubId: clubId!)
                        }
                    } else {
                        var description = club["description"] as? String
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
                    self?.delegate?.displayError(error: "Получены некорректные данные с сервера.\n====\nПодробности: \(error)")
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
