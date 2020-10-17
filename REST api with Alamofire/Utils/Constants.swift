//
//  Constants.swift
//  REST api with Alamofire
//
//  Created by 창민 on 2020/10/17.
//

import Foundation

enum SEGU_ID{
    static let USER_LIST_VC = "goToUserListVC"
    static let PHOTO_COLLECTION_VC = "goToPhotoCollectionVC"
}

enum API{
    static let BASE_URL: String = "https://api.unsplash.com/"
    static let ClIENT_ID: String = "pZHHAytGnH37kQdHKINc4jdi3doWy57L36U-_7x_ORw"
    
}

enum NOTIFICATION{
    enum API {
        static let AUTH_FAIL = "authentication_fail"
    }
}
