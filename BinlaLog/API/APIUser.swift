//
//  APIUser.swift
//  BinlaLog
//
//  Created by Tanakorn on 12/25/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import UIKit
class APIUser:API{
    static func login(username:String,password:String,finish: @escaping (_ response: String) -> Void,fail: @escaping  (_ error: String) -> Void){
        let parameter = ["username":username,"password":password]
        self.request(urlType: .service, httpMethod: .post, path: "login", parameter: parameter, success: {(success) in
            if let type = success.value(forKey: "type") as? String{
                if type == "login"{
                    BackUser.getInstance().login(success: success)
                    finish("")
                }else{
                    fail("")
                }
            }
        }, failure: {(error) in
            fail("")
        })
    }
    static func getUserInfo(finish: @escaping (_ response: NSDictionary) -> Void){
        self.request(urlType: .service, httpMethod: .get, path: "userInfo", parameter: [:], success: {(success) in
            finish(success)
        }, failure: {(error) in
        })
    }
    static func updateUserInfo(phoneno:String,nickname:String,finish: @escaping (_ response: NSDictionary) -> Void){
        let parameter = ["phoneno":phoneno,"nickname":nickname]
        self.request(urlType: .service, httpMethod: .put, path: "userInfo", parameter: parameter, success: {(success) in
            print(success)
            finish(success)
        }, failure: {(error) in
        })
    }
    static func uploadProfilePic(image:UIImage,key:String,finish: @escaping (_ response: NSDictionary) -> Void){
        let parameter = ["key":key]
        self.upload(image:image,urlType: .service, httpMethod: .post, path: "userInfo/image/profile", parameter: parameter, success: {(success) in
            finish(success)
        }, failure: {
        })
    }
    static func getRank(success: @escaping (_ response: NSDictionary) -> Void){
        let parameter = ["data":"true"]
        self.request(urlType: .service, httpMethod: .get, path: "userInfo/rank", parameter: parameter, success: {(finish) in
            success(finish)
        }, failure: {(error) in
        })
    }
}
