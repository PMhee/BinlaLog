//
//  APIPatient.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/5/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
class APIPatient:API{
    static func listSymptom(finish: @escaping (_ response: NSDictionary) -> Void,fail: @escaping  (_ error: String) -> Void){
        //let parameter = ["data":"true"]
        self.request(urlType: .service, httpMethod: .get, path: "meta/symptom/list", parameter: [:], success: {(success) in
            finish(success)
        }, failure: {(error) in
            fail("")
        })
    }
    static func listDiagnosis(keyword:String,finish: @escaping (_ response: NSDictionary) -> Void,fail: @escaping  (_ error: String) -> Void){
        //let parameter = ["keyword":keyword,"data":"true"]
        self.request(urlType: .service, httpMethod: .get, path: "meta/diagnosis/list", parameter: [:], success: {(success) in
            finish(success)
        }, failure: {(error) in
            fail("")
        })
    }
    static func listDisease(finish: @escaping (_ response: NSDictionary) -> Void,fail: @escaping  (_ error: String) -> Void){
        //let parameter = ["data":"true"]
        self.request(urlType: .service, httpMethod: .get, path: "meta/disease/list", parameter: [:], success: {(success) in
            finish(success)
        }, failure: {(error) in
            fail("")
        })
    }
    static func getPatient(hn:String,finish: @escaping (_ response: NSDictionary) -> Void,fail: @escaping  (_ error: String) -> Void){
        self.request(urlType: .service, httpMethod: .get, path: "meta/disease/list", parameter: [:], success: {(success) in
            finish(success)
        }, failure: {(error) in
            fail("")
        })
    }
}
