//
//  MyAlamofieManager.swift
//  REST api with Alamofire
//
//  Created by 창민 on 2020/10/17.
//

import Foundation
import Alamofire
import SwiftyJSON

final class MyAlamofireManager {
    
    // 싱글톤 적용
    static let shared = MyAlamofireManager()
    
    // 인터셉터
    let interceptors = Interceptor(interceptors:[BaseInterceptor()])
    
    // 로거 설정
    let monitors = [MyLogger()] as [EventMonitor]
    
    // 세션 설정
    var session: Session
    
    private init(){
        session = Session(
            interceptor: interceptors,
            eventMonitors: monitors
        )
    }
    
    func getPhotos(searchTerm userInput: String, complition: @escaping(Result<[Photo],MyError>) -> Void){
        
        print("MyAlamofireManager - getPhotos() called : \(userInput)")
        
        self
            .session
            .request(MySearchRouter.searchPhotos(term: userInput))
            .validate(statusCode: 200..<401)
            .responseJSON(completionHandler:{ response in
                
                guard let responseValue = response.value else { return }
                
                var photos = [Photo]()
                
                let responseJson = JSON(response.value!)
                
                let jsonArray = responseJson["results"]
                
                print("jsonArray.size : \(jsonArray.count)")
                
                for (index, subJson): (String, JSON) in jsonArray{
                    print("index : \(index), subJSON : \(subJson)")
                    
                    // 데이터 파싱
                    let thumbnail = subJson["urls"]["thumb"].string ?? ""
                    let username = subJson["user"]["username"].string ?? ""
                    let likesCount = subJson["likes"].intValue ?? 0
                    let createdAt = subJson["created_at"].string ?? ""
                    
                    let photoItem = Photo(thumbnail: thumbnail, username: username, likesCount: likesCount, createdAt: createdAt)
                    
                    // 배열(photos) 에 넣고
                    photos.append(photoItem)
                }
                
                // 데이터가 있다
                if photos.count > 0 {
                    complition(.success(photos))
                    print(photos[0].username)
                } else {    // 데이터가 없다.
                    complition(.failure(.noContent))
                }
            })
            
        
    }
}
