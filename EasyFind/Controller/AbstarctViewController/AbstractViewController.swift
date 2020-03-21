//
//  AbstractViewController.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2020-03-18.
//  Copyright © 2020 Ramanpreet Singh. All rights reserved.
//

import UIKit

class AbstractViewController: UIViewController {

    class var control: AbstractViewController {
        return UIStoryboard.main.instantiateViewController(withIdentifier: String(describing: self)) as! AbstractViewController
    }
}
