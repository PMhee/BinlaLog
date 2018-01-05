//
//  API.swift
//  BinlaLog
//
//  Created by Tanakorn on 12/25/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import Alamofire
class API{
    private let url_service = "https://ilogbook.md.chula.ac.th/service.php?q=mdlogbook/api/"
    private let url_rest = "https://ilogbook.md.chula.ac.th/rest.php/mdlogbook/"
    private let appid = "68ad50cf9341d14a1122da5b00bcfab80c943181"
    private let appsecret = "e24968be22f4f750f700e9f1523574ed"
    private var header = [String:String]()
    static func request(urlType:URLType,httpMethod:HTTPMethod,path:String,parameter:[String:Any],success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping  (_ error: NSError?) -> Void){
        var url = ""
        switch urlType {
        case .service:
            url = "https://ilogbook.md.chula.ac.th/service.php?q=mdlogbook/api/"
        case .rest:
            url = "https://ilogbook.md.chula.ac.th/rest.php/mdlogbook/"
        }
        let code = "\(url)\(path)"
        var sessionid = ""
        if let user = BackUser.getInstance().get(){
            sessionid = user.sessionid
        }
        let header = ["deeappid":"68ad50cf9341d14a1122da5b00bcfab80c943181","deeappsecret":"e24968be22f4f750f700e9f1523574ed","deesessionid":sessionid]
        Alamofire.request(code, method: httpMethod, parameters: parameter, encoding: URLEncoding.default, headers: header)
            .responseJSON { response in
                //debugPrint(response.result.value)
                if response.result.isSuccess{
                    success((response.result.value as? NSDictionary)!)
                }else{
                    failure(NSError(domain: "Slow Internet Connection", code: 401, userInfo: nil))
                }
                
        }
    }
}
enum URLType{
    case service
    case rest
}
