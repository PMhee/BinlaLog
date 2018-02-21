//
//  APIProcedure.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/5/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
class APIProcedure:API{
    static func listProcedure(finish: @escaping (_ response: NSDictionary) -> Void,fail: @escaping  (_ error: String) -> Void){
        let parameter = ["data":"true"]
        self.request(urlType: .service, httpMethod: .get, path: "meta/proceduregroup/list", parameter: parameter, success: {(success) in
            finish(success)
        }, failure: {(error) in
            fail("")
        })
    }
    static func listProcedure(courseid:String,finish: @escaping (_ response: NSDictionary) -> Void,fail: @escaping  (_ error: String) -> Void){
        let parameter = ["data":"true"]
        self.request(urlType: .service, httpMethod: .get, path: "course/id/\(courseid)/proceduregroup/list", parameter: parameter, success: {(success) in
            finish(success)
        }, failure: {(error) in
            fail("")
        })
    }
}
