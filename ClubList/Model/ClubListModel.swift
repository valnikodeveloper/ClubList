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

struct CustomError {
    var descrition = ""
}

class ClubListModel: NSObject {

    func requestInfoFromSite(urlStr:String,clubDataRelCallBack:@escaping (ClubListData?,CustomError?) ->()) {
        let url = URL(string:urlStr)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let err = error {
                DispatchQueue.main.async {
                    clubDataRelCallBack(nil,CustomError(descrition: err.localizedDescription))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    clubDataRelCallBack(nil,CustomError(descrition: "Не удалось получить данные с сервера"))
                }
                return
            }
            do {
                let jsonResponse = try JSONDecoder().decode([ClubListData].self, from: data)
                for club in (jsonResponse) {
                    var clubData = ClubListData()
                    
                    clubData.id = club.id
                    if clubData.id == nil {
                        clubData.id = "nil"
                    }
                    clubData.name = club.name
                    if club.name == nil {
                        clubData.name = "NO NAME"
                    }
                    //No need to check here.Should be checked in description controller
                    clubData.description = club.description
                    DispatchQueue.main.async {
                        clubDataRelCallBack(clubData, nil)
                    }
                }
            }catch let error {
                DispatchQueue.main.async {
                    clubDataRelCallBack(nil,CustomError(descrition: "Неудалось разобрать данные с сервера.\n====\nПодробности: \(error.localizedDescription)") )
                }
            }
        }.resume()
    }
}
