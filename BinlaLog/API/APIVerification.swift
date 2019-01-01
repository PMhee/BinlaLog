//
//  APIVerification.swift
//  BinlaLog
//
//  Created by Tanakorn on 8/2/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
class APIVerification:API{
    static func getVerification(finish: @escaping (_ response: NSDictionary) -> Void,fail: @escaping (_ response: NSError?) -> Void){
        self.request(urlType: .service, httpMethod: .get, path: "verification/verifycode", parameter: [:], success: {(success) in
            finish(success)
        }, failure: {(error) in
            fail(error)
        })
    }
    static func editVerification(expire:Int,finish: @escaping (_ response: NSDictionary) -> Void,fail: @escaping () -> Void){
        let parameter = ["expireIn":expire]
        self.request(urlType: .service, httpMethod: .put, path: "verification/verifycode", parameter: parameter, success: {(success) in
            finish(success)
        }, failure: {(error) in
            fail()
        })
    }
    static func updateLimit(limit:Int,finish: @escaping (_ response: NSDictionary) -> Void,fail: @escaping () -> Void){
        let parameter = ["timesUsable":limit]
        self.request(urlType: .service, httpMethod: .put, path: "verification/verifycode", parameter: parameter, success: {(success) in
            finish(success)
        }, failure: {(error) in
            fail()
        })
    }
    static func cancelVerification(finish: @escaping (_ response: NSDictionary) -> Void,fail: @escaping () -> Void){
        self.request(urlType: .service, httpMethod: .put, path: "verification/verifycode/cancel", parameter: [:], success: {(success) in
            finish(success)
        }, failure: {(error) in
            fail()
        })
    }
    static func requestVerification(expire:Int,finish: @escaping (_ response: NSDictionary) -> Void,fail: @escaping () -> Void){
        let parameter = ["expireIn":expire]
        self.request(urlType: .service, httpMethod: .post, path: "verification/verifycode", parameter: parameter, success: {(success) in
            finish(success)
        }, failure: {(error) in
            fail()
        })
    }
}
