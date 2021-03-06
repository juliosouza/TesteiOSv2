//
//  LoginModels.swift
//  TesteiOSV2
//
//  Created by Julio Cezar de Souza on 30/05/20.
//  Copyright (c) 2020 Julio Souza. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

//{
//    "userAccount": {
//        "userId": 1,
//        "name": "Jose da Silva Teste",
//        "bankAccount": "2050",
//        "agency": "012314564",
//        "balance": 3.3445
//    },
//    "error": {}
//}

enum Login {
    
    struct Response: Codable {
        let userAccount: UserAccount
        let error: Error
    }
    
    struct UserAccount: Codable {
        let userId: Int?
        let name: String?
        let bankAccount: String?
        let agency: String?
        let balance: Double?
    }
    
    struct Error: Codable {
        let code: Int?
        let message: String?
    }
    
    struct Request {
        let service: LoginAPI
        let postObject: PostObject
    }
    
    struct PostObject: Codable {
        let user: String
        let password: String
        
        init(user: String, password: String) {
            self.user = user
            self.password = password
        }
    }
    
    enum LoginAPI {
        case post
    }

}

extension Login.LoginAPI: Endpoint {
    var base: String {
        return Constants.baseURL
    }
    
    var path: String {
        switch self {
        case .post: return Constants.login
        }
    }
}

