//
//  NViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/10/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
protocol NViewControllerDelegate {
    func loadTop(success:@escaping () -> Void)
    func loadBottom(success:@escaping () -> Void)
}

