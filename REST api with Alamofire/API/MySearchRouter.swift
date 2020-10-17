//
//  MySearchRouter.swift
//  REST api with Alamofire
//
//  Created by 창민 on 2020/10/17.
//

import Foundation
import Alamofire

// 검색관련 api
enum MySearchRouter: URLRequestConvertible {
    
    case searchPhotos(term: String)
    case searchUsers(term: String)
//    case get([String: String]), post([String: String])
    
    var baseURL: URL {
        return URL(string: API.BASE_URL + "search/")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchPhotos, .searchUsers:
            return .get
        }
    }
    
    var endPoint: String {
        switch self {
        case .searchPhotos:
            return "photos/"
        case .searchUsers:
            return "users/"
        }
    }
    
    var parameters: [String: String]{
        switch self {
        case let .searchUsers(term), let .searchPhotos(term):
            return ["query" : term]
        }
    }
    
    // 실제 api를 발동하면 실행되는 부분
    func asURLRequest() throws -> URLRequest {
        
        let url = baseURL.appendingPathComponent(endPoint)
        print("MySearchRouter - asURLRequest()")
        
        var request = URLRequest(url: url)
        request.method = method
        
        request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        
//        switch self {
//        case let .get(parameters):
//            request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
//        case let .post(parameters):
//            request = try JSONParameterEncoder().encode(parameters, into: request)
//        }
        
        return request
    }
}
