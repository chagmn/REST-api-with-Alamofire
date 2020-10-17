//
//  ViewController.swift
//  REST api with Alamofire
//
//  Created by 창민 on 2020/10/17.
//

import UIKit
import Alamofire
import Toast_Swift

class HomeVC: BaseVC, UISearchBarDelegate, UIGestureRecognizerDelegate{


    @IBOutlet weak var searachFileterSegment: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchIndicator: UIActivityIndicatorView!
    
    var keyboardDismissTabGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    
    //MARK: - override method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.config()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.searchBar.becomeFirstResponder()   // 포커싱
    }
    
    // 화면이 넘어가기 전에 준비
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case SEGU_ID.USER_LIST_VC:
            let nextVC = segue.destination as! UserListVC
            
            guard let userInputValue = self.searchBar.text else {
                return
            }
            
            nextVC.vcTitle = userInputValue
            
        case SEGU_ID.PHOTO_COLLECTION_VC:
            let nextVC = segue.destination as! PhotoCollectionVC
            
            guard let userInputValue = self.searchBar.text else {
                return
            }
            
            nextVC.vcTitle = userInputValue
            
        default:
            print("default")
        }
    }

    //MARK - fileprivate methods
    //UI 설정
    fileprivate func config(){
        self.searchButton.layer.cornerRadius = 10
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.delegate = self
        self.keyboardDismissTabGesture.delegate = self
        self.view.addGestureRecognizer(keyboardDismissTabGesture)
    }
    
    fileprivate func pushVC(){
        var segueID: String = ""
        
        switch searachFileterSegment.selectedSegmentIndex {
        case 0:
            segueID = "goToPhotoCollectionVC"
        case 1:
            segueID = "goToUserListVC"
        default:
            segueID = "goToPhotoCollectionVC"
        }
        
        self.performSegue(withIdentifier: segueID, sender: self)
    }
    
    @objc func keyboardWillShowHandle(notification: NSNotification){
        //키보드 사이즈 가져오기
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            
            // 버튼이 키보드에 덮힐 때
            if keyboardSize.height < searchButton.frame.origin.y{
                let distance = keyboardSize.height - searchButton.frame.origin.y
                
                self.view.frame.origin.y = distance + searchButton.frame.height
            }
        }
    }
    
    @objc func keyboardWillHideHandle(){
        self.view.frame.origin.y = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 키보드 올라가는 이벤트 받는 처리
        // 키보드 노티 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowHandle(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandle), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
        // 키보드 노티 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - IBAction methods
    @IBAction func onSearchButtonClicked(_ sender: UIButton) {
        
        let url = API.BASE_URL + "search/photos"
        
        guard let userInput = self.searchBar.text else { return }
        // 키, 값 형식 딕셔너리
//        let queryParam = ["query" : userInput, "client_id" : API.ClIENT_ID]
//        AF.request(url, method: .get, parameters: queryParam).responseJSON(completionHandler: { response in
//            debugPrint(response)
//        })

        var urlToCall: URLRequestConvertible?
        
        switch searachFileterSegment.selectedSegmentIndex {
        case 0:
            urlToCall = MySearchRouter.searchPhotos(term: userInput)
            
            MyAlamofireManager
                .shared
                .getPhotos(searchTerm: userInput,
                           complition: { [weak self] result in
                            guard let self = self else { return }
                            
                    switch result {
                    case .success(let fetchedPhotos):
                        print("HomeVC - getPhotos.succes - fetchedPhotos.count : \(fetchedPhotos.count)")
                    case .failure(let error):
                        print("HomeVC - getPhotos.failure - error : \(error.rawValue)")
                        self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
                    }
                    
            })
        case 1:
            urlToCall = MySearchRouter.searchUsers(term: userInput)
  
        default:
            print("default")
        }
        
//        if let urlConvertible = urlToCall {
//            MyAlamofireManager
//                .shared
//                .session
//                .request(MySearchRouter.searchPhotos(term: userInput))
//                .validate(statusCode: 200..<401)
//                .responseJSON(completionHandler:
//            { response in
//                debugPrint(response)
//            })
//        }
        pushVC()
    }
    
    @IBAction func searchFilterValueChanged(_ sender: UISegmentedControl) {
        
        var searchBarTitle = ""
        
        switch sender.selectedSegmentIndex {
        
        case 0:
            searchBarTitle = "사진 키워드"
        case 1:
            searchBarTitle = "사용자 이름"
        default:
            searchBarTitle = "사진 키워드"
        }
        
        self.searchBar.placeholder = searchBarTitle + "입력"
      
       // self.searchBar.resignFirstResponder()   // 포커싱 해제
    }
    
    //MARK: - UISearchBar Delegate Methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let userInputString = searchBar.text else { return }
        if userInputString.isEmpty{
            self.view.makeToast("검색 키워드를 입력해주세요.", duration: 1.0 , position: .top )
        } else {
            pushVC()
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchText.isEmpty){
            self.searchButton.isHidden = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                searchBar.resignFirstResponder()
            })
        } else{
            self.searchButton.isHidden = false
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let inputTextCount = searchBar.text?.appending(text).count ?? 0
        
        if (inputTextCount > 12){
            self.view.makeToast("12자만 입력 가능합니다.", duration: 1.0 , position: .top )
        }
        return inputTextCount <= 12
    }
    
    //MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if touch.view?.isDescendant(of: searachFileterSegment) == true {
            return false
        } else if touch.view?.isDescendant(of: searchBar) == true {
            return false
        } else {
            view.endEditing(true)
            return true
        }

    }
}

