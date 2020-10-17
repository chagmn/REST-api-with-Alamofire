//
//  BaseVC.swift
//  REST api with Alamofire
//
//  Created by 창민 on 2020/10/17.
//

import Foundation
import UIKit

class BaseVC: UIViewController{
    
    var vcTitle: String = "" {
        didSet{
            self.title = vcTitle
        }
    }
}
