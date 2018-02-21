//
//  API.swift
//  BinlaLog
//
//  Created by Tanakorn on 12/25/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
class API{
    private var header = [String:String]()
    static func request(urlType:URLType,httpMethod:HTTPMethod,path:String,parameter:[String:Any],success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping  (_ error: NSError?) -> Void){
        let code = "\(Constant().getLink())\(path)"
        var sessionid = ""
        if let user = BackUser().get(){
            sessionid = user.sessionid
        }
        
        var header = Constant().getHeader()
        header["sessionid"] = sessionid
        Alamofire.request(code, method: httpMethod, parameters: parameter, encoding: URLEncoding.default, headers: header)
            .responseJSON { response in
               // debugPrint(response)
                if response.result.isSuccess{
                    if let res = response.result.value as? NSDictionary{
                        success(res)
                    }else{
                        failure(NSError(domain: "Slow Internet Connection", code: 401, userInfo: nil))
                    }
                }else{
                    failure(NSError(domain: "Slow Internet Connection", code: 401, userInfo: nil))
                }
                
        }
    }
    static func upload(image:UIImage?,urlType:URLType,httpMethod:HTTPMethod,path:String,parameter:[String:String],success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping  () -> Void){
        let code = "\(Constant().getLink())\(path)"
        var sessionid = ""
        if let user = BackUser().get(){
            sessionid = user.sessionid
        }
        var header = Constant().getHeader()
        header["sessionid"] = sessionid
        if image != nil{
            Alamofire.upload(multipartFormData: {(multiple) in
                if let data = UIImageJPEGRepresentation(image!,1.0) {
                    multiple.append(data, withName: "picfile", fileName: "profile.jpg", mimeType: "image/jpeg")
                }
                for (key, value) in parameter {
                    multiple.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }, to: code,
               headers:header,
               encodingCompletion: {(complete) in
                //print(complete)
                switch complete {
                case .success(let upload, _, _):
                    upload.responseJSON {
                        response in
                        if let JSON = response.result.value {
                            success(JSON as! NSDictionary)
                            print("JSON: \(JSON)")
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            })
        }else{
            failure()
        }
    }
    static func getPicture(url:String,success: @escaping (_ response: UIImage) -> Void){
        let code = "\(url)"
        var sessionid = ""
        if let user = BackUser().get(){
            sessionid = user.sessionid
        }
        var header = Constant().getHeader()
        header["sessionid"] = sessionid
        Alamofire.request(code, method: .get,headers:header).responseImage { response in
            guard let image = response.result.value else {
                // Handle error
                return
            }
            success(image)
            // Do stuff with your image
        }
    }
}
enum URLType{
    case service
    case rest
}
