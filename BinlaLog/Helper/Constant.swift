//
//  Constant.swift
//  BinlaLog
//
//  Created by Tanakorn on 12/25/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import UIKit
class Constant{
    #if MDCULOG
    private let appName = "MDCULog"
    private let colorMain = 0x2EB187
    private let logo = "mdculog-logo.jpg"
    private let link = "https://ilogbook.md.chula.ac.th/newapi/api/v1/"
    private let header = ["appid":"68ad50cf9341d14a1122da5b00bcfab80c943181","appsecret":"e24968be22f4f750f700e9f1523574ed","Accept":"application/json"]
    #elseif GILOG
    private let appName = "GILog"
    private let colorMain = 0x2EB187
    private let logo = "mdculog-logo.jpg"
    private let link = "https://ilogbook.md.chula.ac.th/laravel/api/v1/"
    private let header = ["appid":"68ad50cf9341d14a1122da5b00bcfab80c943181","appsecret":"e24968be22f4f750f700e9f1523574ed","Accept":"application/json"]
    #else
    private let appName = "BinlaLog"
    private let colorMain = 0x000080
    private let logo = "Logo.png"
    private let link = "http://binlalog.medicine.psu.ac.th/binla/api/v1/"
    private let header = ["appid":"67ce627d50a0ea834172b5bf4d794d3143e97483","appsecret":"f44e3569e2a2f27801f8a493bb8bdc1f","Accept":"application/json"]
    #endif
    private let fburl = "fb://profile/1852404088340314"
    private let dateFormat :String = "yyyy-MM-dd'T'HH:mm:ssZ"
    private let lv_easy = UIColor(red: 84/255, green: 175/255, blue: 232/255, alpha: 1.0)
    private let lv_medium = UIColor(red: 122/255, green: 92/255, blue: 163/255, alpha: 1.0)
    private let lv_hard = UIColor(red: 247/255, green: 179/255, blue: 50/255, alpha: 1.0)
    func getAppName() ->String{
        return self.appName
    }
    func getColorMain() ->UIColor{
        return UIColor(netHex:self.colorMain)
    }
    func getLogo() ->String{
        return self.logo
    }
    func getDateFormat() ->String{
        return self.dateFormat
    }
    func getLvEasy() ->UIColor{
        return self.lv_easy
    }
    func getLvMedium() ->UIColor{
        return self.lv_medium
    }
    func getLvHard() ->UIColor{
        return self.lv_hard
    }
    func getFacebookURL() ->String{
        return self.fburl
    }
    func getLink() ->String{
        return self.link
    }
    func getHeader() -> [String:String]{
        return self.header
    }
}
