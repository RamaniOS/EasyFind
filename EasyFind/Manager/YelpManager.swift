//
//  YelpManager.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2020-03-19.
//  Copyright © 2020 Ramanpreet Singh. All rights reserved.
//

import Alamofire

/// Class reponsible for fetch data from YELP API
class YelpManager {
 
    static func fetchYelpBusinesses(with offset: Int, location: String, completion: @escaping(_: BaseBusiness?) -> Void) {
        
        let parameters: Parameters = ["location": location,
                                      "offset": offset]
        
        let url = URL(string: "https://api.yelp.com/v3/businesses/search")
        
        // request from Alamofire
        APIManager.requestWith(url!, parameters: parameters) { (base: BaseBusiness?) in
            guard let baseModel = base else {
                completion(nil)
                return
            }
            completion(baseModel)
        }
    }
}
