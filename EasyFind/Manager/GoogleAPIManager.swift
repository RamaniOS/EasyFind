//
//  GoogleAPIManager.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2020-03-21.
//  Copyright © 2020 Ramanpreet Singh. All rights reserved.
//

import Alamofire
import CoreLocation

/// Class reponsible for fetch data from Google API
class GoogleAPIManager {
 
    static func fetchDirections(from origin: Coordinates, to destination: Coordinates, completion: @escaping(_: BaseDirection?) -> Void) {
        
        let origin = "\(origin.latitude!),\(origin.longitude!)"
        let destination = "\(destination.latitude!),\(destination.longitude!)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\(Google_Direction_API_Key)"
        
        // request from Alamofire
        APIManager.requestWith(url) { (base: BaseDirection?) in
            guard let baseModel = base else {
                completion(nil)
                return
            }
            completion(baseModel)
        }
    }
}
