//
//  APINotification.swift
//  BinlaLog
//
//  Created by Tanakorn on 13/2/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
class APINotification:API{
    static func listNotificationLogbook(updatetime:String,finish: @escaping (_ response: NSDictionary) -> Void,fail: @escaping () -> Void){
        let parameter = ["after":updatetime]
        self.request(urlType: .service, httpMethod: .get, path: "verification/verifycode/logbook/procedure/list", parameter: parameter, success: {(success) in
            finish(success)
        }, failure: {(error) in
            fail()
        })
    }
    static func listNotificationPatientCare(updatetime:String,finish: @escaping (_ response: NSDictionary) -> Void,fail: @escaping () -> Void){
        let parameter = ["after":updatetime]
        self.request(urlType: .service, httpMethod: .get, path: "verification/verifycode/logbook/patientcare/list", parameter: parameter, success: {(success) in
            finish(success)
        }, failure: {(error) in
            fail()
        })
    }
    static func listNotificationLogbook(before:String,finish: @escaping (_ response: NSDictionary) -> Void,fail: @escaping () -> Void){
        let parameter = ["before":before]
        self.request(urlType: .service, httpMethod: .get, path: "verification/verifycode/logbook/procedure/list", parameter: parameter, success: {(success) in
            finish(success)
        }, failure: {(error) in
            fail()
        })
    }
    static func listNotificationPatientCare(before:String,finish: @escaping (_ response: NSDictionary) -> Void,fail: @escaping () -> Void){
        let parameter = ["before":before]
        self.request(urlType: .service, httpMethod: .get, path: "verification/verifycode/logbook/patientcare/list", parameter: parameter, success: {(success) in
            finish(success)
        }, failure: {(error) in
            fail()
        })
    }
    static func updateCommentLogbook(message:String,verifystatus:Int,verifycodeid:String,logbookid:String,finish: @escaping (_ response: NSDictionary) -> Void,fail: @escaping () -> Void){
        let parameter = ["verifymessage":message,"verifystatus":verifystatus] as [String : Any]
        self.request(urlType: .service, httpMethod: .put, path: "verification/verifycode/id/\(verifycodeid)/logbook/procedure/id/\(logbookid)/status", parameter: parameter, success: {(success) in
            finish(success)
        }, failure: {(error) in
            fail()
        })
    }
    static func updateCommentPatient(message:String,verifystatus:Int,verifycodeid:String,patientid:String,finish: @escaping (_ response: NSDictionary) -> Void,fail: @escaping () -> Void){
        let parameter = ["verifymessage":message,"verifystatus":verifystatus] as [String : Any]
        self.request(urlType: .service, httpMethod: .put, path: "verification/verifycode/id/\(verifycodeid)/logbook/patientcare/id/\(patientid)/status", parameter: parameter, success: {(success) in
            print(success)
            finish(success)
        }, failure: {(error) in
            fail()
        })
    }
}
