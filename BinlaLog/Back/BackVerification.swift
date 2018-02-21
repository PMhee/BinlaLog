//
//  BackVerification.swift
//  BinlaLog
//
//  Created by Tanakorn on 8/2/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class BackVerification:Back{
    static func getInstance() ->BackVerification{
        return BackVerification()
    }
    func loadCode(content:NSDictionary){
        var verification = Verification()
        try! Realm().write {
            if let id = content.value(forKey: "id") as? String{
                verification.id = id
                if self.get(id: id) != nil{
                    verification = self.get(id:id)!
                }
            }
            if let createtime = content.value(forKey: "createtime") as? String{
                verification.createtime = createtime.convertToDate()
            }
            if let expiretime = content.value(forKey: "expiretime") as? String{
                verification.expiretime = expiretime.convertToDate()
            }
            if let canceltime = content.value(forKey: "canceltime") as? String{
                verification.canceltime = canceltime.convertToDate()
            }
            if let lbuserid = content.value(forKey: "lbuserid") as? String{
                verification.lbuserid = lbuserid
            }
            if let verifycode = content.value(forKey: "verifycode") as? String{
                verification.verifycode = verifycode
            }
            if self.get(id: verification.id) == nil{
                self.post(object: verification)
            }
        }
        if let generator = content.value(forKey: "generator") as? NSDictionary{
            BackUser.getInstance().loadPerson(content: generator)
        }
        
    }
    func enumCode(finish:@escaping () -> Void,fail:@escaping (_ response :String) -> Void){
        APIVerification.getVerification(finish: {(success) in
            if let message = success.value(forKey: "message") as? String{
                if message == "Not Found" || message == "Record Not Found"{
                    fail("notfound")
                }else if message == "success"{
                    if let content = success.value(forKey: "content") as? NSDictionary{
                        self.loadCode(content: content)
                        finish()
                    }
                }
            }
        }, fail: {
            fail("internet")
        })
    }
    func requestVerification(expire:Int,finish:@escaping () ->Void){
        APIVerification.requestVerification(expire: expire, finish: {(success) in
            if let content = success.value(forKey: "content") as? NSDictionary{
                self.loadCode(content: content)
            }
            finish()
        }, fail: {
        })
    }
    func editVerification(expire:Int,finish:@escaping () ->Void){
        APIVerification.editVerification(expire: expire, finish: {(success) in
            if let content = success.value(forKey: "content") as? NSDictionary{
                self.loadCode(content: content)
            }
            finish()
        }, fail: {
            
        })
    }
    func cancelVerification(finish:@escaping () ->Void){
        APIVerification.cancelVerification(finish: {(success) in
            if let content = success.value(forKey: "content") as? NSDictionary{
                self.loadCode(content: content)
            }
            finish()
        }, fail: {})
    }
    func get(id:String)->Verification?{
        return try! Realm().objects(Verification.self).filter("id == %@",id).sorted(byKeyPath: "expiretime", ascending: false).first
    }
    func getTeacher(personid:String,date:Date)->Verification?{
        return try! Realm().objects(Verification.self).filter("lbuserid == %@ AND createtime < %@ AND expiretime > %@ AND canceltime == nil",personid,date,date).last
    }
    func getTeacherWithoutCancelTime(personid:String,date:Date)->Verification?{
        return try! Realm().objects(Verification.self).filter("lbuserid == %@ AND createtime < %@ AND expiretime > %@ AND canceltime == nil",personid,date,date).first
    }
}
