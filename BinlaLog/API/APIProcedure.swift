//
//  APIProcedure.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/5/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
class APIPatient:API{
    static func listProcedure(finish: @escaping (_ response: String) -> Void,fail: @escaping  (_ error: String) -> Void){
        let parameter = ["data":"true"]
        self.request(urlType: .service, httpMethod: .post, path: "searchProcedure", parameter: parameter, success: {(success) in
            print(success)
        }, failure: {(error) in
            fail("")
        })
    }
}
