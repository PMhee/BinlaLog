//
//  BackProcedure.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/11/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class BackProcedure{
    static func getInstance() -> BackProcedure{
        return BackProcedure()
    }
    func loadProcedure(dict:NSDictionary){
        try! Realm().write {
            self.loadProcedureGroup(dict: dict)
            if let array = dict.value(forKey: "procedures") as? NSArray{
                for i in 0..<array.count{
                    if let content = array[i] as? NSDictionary{
                        var procedure = Procedure()
                        if let  id = content.value(forKey: "id") as? String{
                            procedure.id = id
                            if self.get(id: id) != nil{
                                procedure = self.get(id: id)!
                            }
                        }
                        if let assistScore = content.value(forKey: "assistScore") as? Int{
                            procedure.assistScore = assistScore
                        }
                        if let des = content.value(forKey: "description") as? String{
                            procedure.des = des
                        }
                        if let name = content.value(forKey: "name") as? String{
                            procedure.name = name
                        }
                        if let performScore = content.value(forKey: "performScore") as? Int{
                            procedure.performScore = performScore
                        }
                        if let picfile = content.value(forKey: "picfile") as? String{
                            procedure.picfile = picfile
                        }
                        if let proctype = content.value(forKey: "proctype") as? Int{
                            procedure.proctype = proctype
                        }
                        if let procgroupid = content.value(forKey: "procgroupid") as? String{
                            procedure.proceduregroup = procgroupid
                        }
                        if let searchKey = content.value(forKey: "searchKey") as? String{
                            procedure.searchKey = searchKey
                        }
                        if let observeMinReq = content.value(forKey: "observeMinReq") as? Int{
                            procedure.observeMinReq = observeMinReq
                        }
                        if let observeScore = content.value(forKey: "observeScore") as? Int{
                            procedure.observeScore = observeScore
                        }
                        if let assistMinReq = content.value(forKey: "assistMinReq") as? Int{
                            procedure.assistMinReq = assistMinReq
                        }
                        if let performMinReq = content.value(forKey: "performMinReq") as? Int{
                            procedure.performMinReq = performMinReq
                        }
                        if self.get(id: procedure.id) == nil{
                            self.post(object: procedure)
                        }
                    }
                }
            }
        }
    }
    func loadProcedureGroup(dict:NSDictionary){
        var procedureGroup = ProcedureGroup()
        try! Realm().write{
            if let id = dict.value(forKey: "id") as? String{
                procedureGroup.id = id
                if self.getGroup(id: id) != nil{
                    procedureGroup = self.getGroup(id: id)!
                }
            }
            if let procgroupdesc = dict.value(forKey: "procgroupdesc") as? String{
                procedureGroup.procgroupdesc = procgroupdesc
            }
            if let progroupname = dict.value(forKey: "procgroupname") as? String{
                procedureGroup.procgroupname = progroupname
            }
            if let picurl = dict.value(forKey: "picurl") as? String{
                #if MDCULOG
                if procedureGroup.procgroupname == "Laboratory Investigation"{
                    procedureGroup.picurl = "ic-lab.png"
                }else{
                    procedureGroup.picurl = "ic-\(procedureGroup.procgroupname.lowercased()).png"
                }
                #else
                procedureGroup.picurl = "ic-lab.png"
                #endif
            }
            if self.getGroup(id: procedureGroup.id) == nil{
                self.post(object: procedureGroup)
            }
        }
    }
    func loadProcedure(content:NSDictionary){
        try! Realm().write {
            var procedure = Procedure()
            if let  id = content.value(forKey: "id") as? String{
                procedure.id = id
                if self.get(id: id) != nil{
                    procedure = self.get(id: id)!
                }
            }
            if let assistScore = content.value(forKey: "assistScore") as? Int{
                procedure.assistScore = assistScore
            }
            if let des = content.value(forKey: "description") as? String{
                procedure.des = des
            }
            if let name = content.value(forKey: "name") as? String{
                procedure.name = name
            }
            if let performScore = content.value(forKey: "performScore") as? Int{
                procedure.performScore = performScore
            }
            if let picfile = content.value(forKey: "picfile") as? String{
                procedure.picfile = picfile
            }
            if let proctype = content.value(forKey: "proctype") as? Int{
                procedure.proctype = proctype
            }
            if let procgroupid = content.value(forKey: "procgroupid") as? String{
                procedure.proceduregroup = procgroupid
            }
            if let searchKey = content.value(forKey: "searchKey") as? String{
                procedure.searchKey = searchKey
            }
            if let observeMinReq = content.value(forKey: "observeMinReq") as? Int{
                procedure.observeMinReq = observeMinReq
            }
            if let observeScore = content.value(forKey: "observeScore") as? Int{
                procedure.observeScore = observeScore
            }
            if let assistMinReq = content.value(forKey: "assistMinReq") as? Int{
                procedure.assistMinReq = assistMinReq
            }
            if let performMinReq = content.value(forKey: "performMinReq") as? Int{
                procedure.performMinReq = performMinReq
            }
            if self.get(id: procedure.id) == nil{
                self.post(object: procedure)
            }
        }
    }
    func isAchieve(procedureid:String) ->Bool{
        return BackRotation.getInstance().listLogbook(procedureid: procedureid).count > 0 ? true : false
    }
    func groupProcedure(procedures:List<Procedure>) ->[String:[Procedure]]{
        var gr = [String:Int]()
        for i in 0..<procedures.count{
            gr[procedures[i].proceduregroup] = 0
        }
        var result = [String:[Procedure]]()
        let arr = Array(procedures)
        for (key, value) in gr {
            result[key] = arr.filter({
                return $0.proceduregroup == key ? true : false
            })
        }
        return result
    }
    func get(id:String) -> Procedure?{
        return try! Realm().objects(Procedure.self).filter("id == %@",id).first
    }
    func getGroup(id:String) -> ProcedureGroup?{
        return try! Realm().objects(ProcedureGroup.self).filter("id == %@",id).first
    }
    func get(key:String) -> Results<Procedure>{
        return try! Realm().objects(Procedure.self).filter("name contains[c] %@ OR des contains[c] %@",key,key)
    }
    func post(object:Object){
        try! Realm().add(object)
    }
    func list(key:String) -> Results<Procedure>{
        return try! Realm().objects(Procedure.self).filter("name contains[c] %@",key).sorted(byKeyPath: "name", ascending: true)
    }
    func list(procgroupid:String) -> Results<Procedure>{
        return try! Realm().objects(Procedure.self).filter("proceduregroup == %@",procgroupid)
    }
    func list(courseid:String,key:String) -> List<Procedure>{
        let arr = List<Procedure>()
        if let course = BackCourse.getInstance().get(id: courseid){
            for i in 0..<course.procgroupids.count{
                if let procgroup = self.getGroup(id: course.procgroupids[i].procgroupid){
                    var res = [Procedure]()
                    if procgroup.procgroupname.lowercased().contains(key.lowercased()){
                        res = Array(try! Realm().objects(Procedure.self).filter("proceduregroup == %@",procgroup.id).sorted(byKeyPath: "name", ascending: true))
                    }else{
                        res = Array(try! Realm().objects(Procedure.self).filter("name contains[c] %@ AND proceduregroup == %@",key,procgroup.id).sorted(byKeyPath: "name", ascending: true))
                    }
                    
                    for j in 0..<res.count{
                        arr.append(res[j])
                    }
                }
            }
        }
        return arr
    }
    func enumProcedure(finish: @escaping () -> Void){
        APIProcedure.listProcedure(finish: {(success) in
            if let content = success.value(forKey: "content") as? NSDictionary{
                if let array = content.value(forKey: "data") as? NSArray{
                    for i in 0..<array.count{
                        if let content = array[i] as? NSDictionary{
                            if let arr = content.value(forKey: "procedures") as? NSArray{
                                for j in 0..<arr.count{
                                    if let json = arr[j] as? NSDictionary{
                                        self.loadProcedure(content: json)
                                    }
                                }
                            }
                            self.loadProcedureGroup(dict: content)
                        }
                    }
                }
            }
            finish()
        }, fail: {(error) in})
    }
    func enumProcedure(courseid:String,finish: @escaping () -> Void,error: @escaping () -> Void){
        APIProcedure.listProcedure(courseid: courseid, finish: {(success) in
            if let content = success.value(forKey: "content") as? NSDictionary{
                if let array = content.value(forKey: "proceduregroups") as? NSArray{
                    BackCourse.getInstance().loadProcgroup(courseid: courseid, procgroup: array)
                    for i in 0..<array.count{
                        if let content = array[i] as? NSDictionary{
                            self.loadProcedureGroup(dict: content)
                            if let arr = content.value(forKey: "procedures") as? NSArray{
                                for j in 0..<arr.count{
                                    if let json = arr[j] as? NSDictionary{
                                        self.loadProcedure(content: json)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            finish()
        }, fail: {(e) in error()})
    }
}
