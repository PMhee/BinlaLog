//
//  Constant.swift
//  BinlaLog
//
//  Created by Tanakorn on 12/25/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
class Constant{
    private let appName = "Binla Log"
    private let colorMain = 0x000080
    private let logo = "Logo.png"
    func getAppName() ->String{
        return self.appName
    }
    func getColorMain() ->Int{
        return self.colorMain
    }
    func getLogo() ->String{
        return self.logo
    }
}
