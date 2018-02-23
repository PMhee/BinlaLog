//
//  BackNotification.swift
//  BinlaLog
//
//  Created by Tanakorn on 13/2/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class BackNotification:Back{
    static func getInstance() ->BackNotification{
        return BackNotification()
    }
    func removeNotification(){
        try! Realm().write {
            BackUser.getInstance().get()?.notificationLogbook.removeAll()
            BackUser.getInstance().get()?.notificationPatient.removeAll()
        }
    }
    func loadNotificationLogbook(content:NSDictionary){
        try! Realm().write {
            if let id = content.value(forKey: "id") as? String{
                let logbookid = ForeignLogbook()
                logbookid.logbookid = id
                BackUser.getInstance().get()?.notificationLogbook.append(logbookid)
            }
        }
    }
    func loadNotificationPatient(content:NSDictionary){
        try! Realm().write {
            if let id = content.value(forKey: "id") as? String{
                let logbookid = ForeignLogbook()
                logbookid.logbookid = id
                BackUser.getInstance().get()?.notificationLogbook.append(logbookid)
            }
        }
    }
    func enumNotification(finish:@escaping() -> Void){
       APINotification.listNotificationLogbook(updatetime: self.getLogbookLastUpdatetime()?.convertToServer() ?? "", finish: {(success) in
        if let content = success.value(forKey: "content") as? NSDictionary{
            if let array = content.value(forKey: "data") as? NSArray{
                self.removeNotification()
                for i in 0..<array.count{
                    if let data = array[i] as? NSDictionary{
                        BackRotation.getInstance().loadLogbook(content: data)
                        self.loadNotificationLogbook(content: data)
                    }
                }
                finish()
            }
        }
       }, fail: {})
       APINotification.listNotificationPatientCare(updatetime: self.getPatientLastUpdatetime()?.convertToServer() ?? "", finish: {(success) in
        if let content = success.value(forKey: "content") as? NSDictionary{
            if let array = content.value(forKey: "data") as? NSArray{
                for i in 0..<array.count{
                    if let data = array[i] as? NSDictionary{
                        BackRotation.getInstance().loadPatientCare(content: data)
                    }
                }
                finish()
            }
        }
       }, fail: {})
    }
    func enumBeforeNotification(finish:@escaping() -> Void){
        APINotification.listNotificationLogbook(before: self.getLogbookOldUpdatetime()?.convertToServer() ?? "", finish: {(success) in
            if let content = success.value(forKey: "content") as? NSDictionary{
                if let array = content.value(forKey: "data") as? NSArray{
                    for i in 0..<array.count{
                        if let data = array[i] as? NSDictionary{
                            BackRotation.getInstance().loadLogbook(content: data)
                        }
                    }
                    finish()
                }
            }
        }, fail: {})
        APINotification.listNotificationPatientCare(before: self.getPatientOldUpdatetime()?.convertToServer() ?? "", finish: {(success) in
            if let content = success.value(forKey: "content") as? NSDictionary{
                if let array = content.value(forKey: "data") as? NSArray{
                    for i in 0..<array.count{
                        if let data = array[i] as? NSDictionary{
                            BackRotation.getInstance().loadPatientCare(content: data)
                        }
                    }
                    finish()
                }
            }
        }, fail: {})
    }
    func updateProcedureComment(viewModel:ProcedureAddViewController.ViewModel,finish:@escaping()->Void){
        APINotification.updateCommentLogbook(message: viewModel.message, verifystatus: viewModel.verifystatus,verifycodeid: viewModel.verificationid, logbookid: viewModel.logbookid, finish: {(success) in
            if let content = success.value(forKey: "content") as? NSDictionary{
                BackRotation.getInstance().loadLogbook(content: content)
            }
            finish()
        }, fail: {})
    }
    func updatePatientComment(viewModel:PatientViewController.ViewModel,finish:@escaping()->Void){
        APINotification.updateCommentPatient(message: viewModel.message, verifystatus: viewModel.verifystatus, verifycodeid: viewModel.verificationid, patientid: viewModel.patientcareid, finish: {(success) in
            if let content = success.value(forKey: "content") as? NSDictionary{
                BackRotation.getInstance().loadPatientCare(content: content)
            }
            finish()
        }, fail: {})
    }
    func listLogbook() ->Results<Logbook>{
        return try! Realm().objects(Logbook.self)
    }
    func listPatient() ->Results<PatientCare>{
        return try! Realm().objects(PatientCare.self)
    }
    func cutDown(list:Results<Logbook>,number:Int){
        let tempList = list.sorted(byKeyPath: "updatetime", ascending: false)
        let deletedList = List<Object>()
        if list.count > number{
            try! Realm().write{
                for i in 0..<tempList.count{
                    if i > number{
                        deletedList.append(tempList[i])
                    }
                }
                for _ in 0..<deletedList.count{
                    try! Realm().delete(deletedList)
                }
            }
        }
    }
    func cutDown(list:Results<PatientCare>,number:Int){
        let tempList = list.sorted(byKeyPath: "updatetime", ascending: false)
        let deletedList = List<Object>()
        if list.count > number{
            try! Realm().write{
                for i in 0..<tempList.count{
                    if i > number{
                        deletedList.append(tempList[i])
                    }
                }
                for _ in 0..<deletedList.count{
                    try! Realm().delete(deletedList)
                }
            }
        }
    }
    func getLogbookLastUpdatetime() ->Date?{
        return try! Realm().objects(Logbook.self).sorted(byKeyPath: "verifytime", ascending: false).first?.updatetime
    }
    func getPatientLastUpdatetime() ->Date?{
        return try! Realm().objects(PatientCare.self).sorted(byKeyPath: "verifytime", ascending: false).first?.updatetime
    }
    func getLogbookOldUpdatetime() ->Date?{
        return try! Realm().objects(Logbook.self).sorted(byKeyPath: "verifytime", ascending: true).first?.updatetime
    }
    func getPatientOldUpdatetime() ->Date?{
        return try! Realm().objects(PatientCare.self).sorted(byKeyPath: "verifytime", ascending: true).first?.updatetime
    }
}
