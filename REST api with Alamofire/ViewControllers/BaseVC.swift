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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //인증 실패 노티피케이션 등록
        NotificationCenter.default.addObserver(self, selector: #selector(showErrorPopup(notification:)), name: NSNotification.Name(rawValue: NOTIFICATION.API.AUTH_FAIL), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 인증 실패 노티피케이션 등록 해제
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICATION.API.AUTH_FAIL), object: nil)
    }
    
    // MARK: - objc methods
    @objc func showErrorPopup(notification: NSNotification){
        print("BaseVC - showErrorPopup() called")
        
        if let data = notification.userInfo?["statusCode"]{
            print("showErrorPopup() data: \(data)")
            
            // 메인 스레드에서 돌리기 -> UI 스레드
            DispatchQueue.main.async {
                self.view.makeToast("검색 키워드를 입력해주세요.", duration: 1.0, position: .center)
            }

        }
    }
}
