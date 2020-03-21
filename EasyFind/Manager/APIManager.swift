//
//  APIManager.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2020-03-19.
//  Copyright © 2020 Ramanpreet Singh. All rights reserved.
//

import Alamofire

/// Class responsible for using alamofire to fetch data from API's
class APIManager {
    
    public static func requestWith<T: Codable>(_ url: URLConvertible, parameters: Parameters? = nil, requestType: HTTPMethod? = .get, completion: @escaping (T?) -> Void) {
        var headers = AF.session.configuration.headers
        // Add the Authorization header
        headers["Authorization"] = "Bearer \(Yelp_API_Key)"
        if NetworkReachabilityManager()!.isReachable {
            AF.request(url, method: requestType!, parameters: parameters, headers: headers).responseData { (response) in
                if let data = response.data {
                    let model = try? JSONDecoder().decode(T.self, from: data)
                    completion(model)
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }
}
