//
//  APIUser.swift
//  BinlaLog
//
//  Created by Tanakorn on 12/25/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
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
}
