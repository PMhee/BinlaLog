//
//  BackUser.swift
//  BinlaLog
//
//  Created by Tanakorn on 12/25/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class BackUser:Back{
    static func getInstance() ->BackUser{
        return BackUser()
    }
    func login(success:NSDictionary){
        if let content = success.value(forKey: "content") as? NSDictionary{
            let user = User()
            if let role = content.value(forKey: "role") as? String{
                user.role = role
            }
            if let sessionid = content.value(forKey: "sessionid") as? String{
                user.sessionid = sessionid
            }
            if self.list().count == 0 {
                self.post(user: user)
            }
        }
    }
    func changePassword(old:String,new:String,success:@escaping ()->Void,error:@escaping () ->Void){
        APIUser.changePassword(old: old, new: new, finish: {(finish) in
            if let type = finish.value(forKey: "type") as? String{
                if type == "error" {
                    if let message = finish.value(forKey: "content") as? String{
                        error()
                    }
                }else{
                    success()
                }
            }
        }, error: {
            error()
        })
    }
    func enumHospital(success:@escaping ()->Void){
        APIUser.getHospital(success: {(json) in
            if let dict = json.value(forKey: "content") as? NSDictionary{
                if let data = dict.value(forKey: "data") as? NSArray{
                    for i in 0..<data.count{
                        if let content = data[i] as? NSDictionary{
                            self.loadHospital(content: content)
                        }
                    }
                }
            }
            success()
        })
    }
    func loadHospital(content:NSDictionary){
        try! Realm().write {
            var hospital = Hospital()
            if let id = content.value(forKey: "id") as? String{
                hospital.id = id
                if let host = self.getHospital(id: id){
                    hospital = host
                }
            }
            if let name = content.value(forKey: "name") as? String{
                hospital.name = name
            }
            if let location = content.value(forKey: "location") as? NSArray{
                hospital.latitude = location.firstObject as? Double ?? 0.0
                hospital.longitude = location.lastObject as? Double ?? 0.0
            }
            self.getHospital(id: hospital.id) == nil ? self.post(object: hospital) : ()
        }
    }
    func loadDepartment(content:NSDictionary){
        var department = Department()
        try! Realm().write {
            if let id = content.value(forKey: "id") as? String{
                if self.getDepartment(id: id) != nil{
                    department = self.getDepartment(id: id)!
                }
                department.id = id
            }
            if let departmentcode = content.value(forKey: "departmentcode") as? String{
                department.departmentcode = departmentcode
            }
            if let departmentdesc = content.value(forKey: "departmentdesc") as? String{
                department.departmentdesc = departmentdesc
            }
            if let departmentname = content.value(forKey: "departmentname") as? String{
                department.departmentname = departmentname
            }
            if self.getDepartment(id: department.id) == nil{
                self.post(object: department)
            }
        }
    }
    func loadPerson(content:NSDictionary){
        var user = Person()
        try! Realm().write {
            if let id = content.value(forKey: "id") as? String{
                if self.getPerson(id: id) != nil{
                    user = self.getPerson(id: id)!
                }
                user.id = id
            }
            if let firstname = content.value(forKey: "firstname") as? String{
                user.firstname = firstname
            }
            if let gender = content.value(forKey: "gender") as? String{
                user.gender = gender
            }
            if let lastname = content.value(forKey: "lastname") as? String{
                user.lastname = lastname
            }
            if let phoneno = content.value(forKey: "phoneno") as? String{
                user.phoneno = phoneno
            }
            if let picurl = content.value(forKey: "picurl") as? String{
                user.picurl = picurl
                API.getPicture(url: picurl, success: {(image) in
                    Helper.saveLocalImage(image: image, id: user.id)
                })
            }
            if let title = content.value(forKey: "title") as? String{
                user.title = title
            }
            if let userid = content.value(forKey: "userid") as? Int{
                user.userid = userid
            }
            if let usertype = content.value(forKey: "usertype") as? Int{
                user.usertype = usertype
            }
            if let studentmeta = content.value(forKey: "studentmeta") as? NSDictionary{
                if let studentid = studentmeta.value(forKey: "studentid") as? String{
                    user.studentid = studentid
                }
            }
            if self.getPerson(id: user.id) == nil{
                self.post(object: user)
            }
        }
        if let department = content.value(forKey: "usermeta") as? NSDictionary{
            try! Realm().write {
                if let departmentids = department.value(forKey: "departmentids") as? NSArray{
                    user.departmentid.removeAll()
                    for i in 0..<departmentids.count{
                        if let id = departmentids[i] as? String{
                            let foreign = ForeignDepartment()
                            foreign.departmentid = id
                            user.departmentid.append(foreign)
                        }
                    }
                }
            }
            if let departments = content.value(forKey: "departments") as? NSArray{
                for i in 0..<department.count{
                    if let depart = departments[i] as? NSDictionary{
                        self.loadDepartment(content: depart)
                    }
                }
            }
        }
    }
    func getUserInfo(finish: @escaping () -> Void){
        APIUser.getUserInfo(){(success) in
            //print(success)
            try! Realm().write {
                if let json = success.value(forKey: "content") as? NSDictionary{
                    if let content = json.value(forKey: "userdata") as? NSDictionary{
                        var user = User()
                        if let id = content.value(forKey: "id") as? String{
                            if self.get() != nil{
                                user = self.get()!
                            }
                            user.id = id
                        }
                        if let advisor = content.value(forKey: "advisor") as? String{
                            user.advisor = advisor
                        }
                        if let studentmeta = content.value(forKey: "studentmeta") as? NSDictionary{
                            if let batch = studentmeta.value(forKey: "batch") as? Int{
                                user.batch = batch
                            }
                            if let enteryear = studentmeta.value(forKey: "enteryear") as? Int{
                                user.enteryear = enteryear
                            }
                            if let entranceMeth = studentmeta.value(forKey: "entranceMeth") as? String{
                                user.entranceMeth = entranceMeth
                            }
                            if let nickname = studentmeta.value(forKey: "nickname") as? String{
                                user.nickname = nickname
                            }
                            if let studentid = studentmeta.value(forKey: "studentid") as? String{
                                user.studentid = studentid
                            }
                            if let studentidno = studentmeta.value(forKey: "studentidno") as? String{
                                user.studentidno = studentidno
                            }
                            if let studentidprefix = studentmeta.value(forKey: "studentidprefix") as? String{
                                user.studentidprefix = studentidprefix
                            }
                            if let studentidsuffix = studentmeta.value(forKey: "studentidsuffix") as? String{
                                user.studentidsuffix = studentidsuffix
                            }
                        }
                        if let coursename = content.value(forKey: "coursename") as? String{
                            user.coursename = coursename
                        }
                        if let email = content.value(forKey: "email") as? String{
                            user.email = email
                        }
                        
                        if let facebook = content.value(forKey: "facebook") as? String{
                            user.facebook = facebook
                        }
                        if let firstname = content.value(forKey: "firstname") as? String{
                            user.firstname = firstname
                        }
                        if let gender = content.value(forKey: "gender") as? String{
                            user.gender = gender
                        }
                        if let isTest = content.value(forKey: "isTest") as? Int{
                            user.isTest = isTest
                        }
                        if let lastname = content.value(forKey: "lastname") as? String{
                            user.lastname = lastname
                        }
                        if let phoneno = content.value(forKey: "phoneno") as? String{
                            user.phoneno = phoneno
                        }
                        if let picurl = content.value(forKey: "picurl") as? String{
                            user.picurl = picurl
                            API.getPicture(url: picurl, success: {(image) in
                                Helper.saveLocalImage(image: image, id: user.id)
                            })
                        }
                        if let place = content.value(forKey: "place") as? String{
                            user.place = place
                        }
                        if let pplid = content.value(forKey: "pplid") as? String{
                            user.pplid = pplid
                        }
                        if let procedures = content.value(forKey: "procedures") as? Int{
                            user.procedure = procedures
                        }
                        if let rank = content.value(forKey: "rank") as? Int{
                            user.rank = rank
                        }
                        if let selfdescription = content.value(forKey: "selfdescription") as? String{
                            user.selfdescription = selfdescription
                        }
                        
                        if let symptoms = content.value(forKey: "symptoms") as? Int{
                            user.symptoms = symptoms
                        }
                        if let title = content.value(forKey: "title") as? String{
                            user.title = title
                        }
                        if let userid = content.value(forKey: "userid") as? Int{
                            user.userid = userid
                        }
                        if let usertype = content.value(forKey: "usertype") as? Int{
                            user.usertype = usertype
                        }
                        if self.get() == nil{
                            self.post(user: user)
                        }
                        finish()
                    }
                }
            }
        }
        
    }
    func selectCurrentRotation(rotationid:[String]){
        try! Realm().write{
            if self.get() != nil{
                let user = self.get()!
                user.currentRotation.removeAll()
                for i in 0..<rotationid.count{
                    let rotation = ForeignRotation()
                    rotation.rotationid = rotationid[i]
                    user.currentRotation.append(rotation)
                }
                user.currentSelectRotation = user.currentRotation.first?.rotationid ?? ""
            }
        }
    }
    func putCurrentRotation(rotationid:[String]){
        try! Realm().write{
            if self.get() != nil{
                let user = self.get()!
                user.currentRotation.removeAll()
                for i in 0..<rotationid.count{
                    let rotation = ForeignRotation()
                    rotation.rotationid = rotationid[i]
                    user.currentRotation.append(rotation)
                }
                if user.currentSelectRotation == ""{
                    user.currentRotation.count > 0 ? user.currentSelectRotation = user.currentRotation.first?.rotationid ?? "" : ()
                }
            }
        }
    }
    func putRecentRotation(rotationid:[String]){
        try! Realm().write{
            if self.get() != nil{
                let user = self.get()!
                user.recentRotation.removeAll()
                for i in 0..<rotationid.count{
                    let rotation = ForeignRotation()
                    rotation.rotationid = rotationid[i]
                    user.recentRotation.append(rotation)
                }
            }
        }
    }
    func putPasscode(viewModel:PasscodeViewController.ViewModel){
        try! Realm().write {
            let user = self.get()
            user?.passcode = viewModel.passcode
        }
    }
    func putFilter(viewModel:FilterViewController.ViewModel){
        try! Realm().write {
            let user = self.get()
            user?.currentSelectVerification = viewModel.selectVerifiaction
            if let listRotation = viewModel.listRotation{
                if listRotation.count > viewModel.selectRotation{
                    user?.currentSelectRotation = viewModel.listRotation![viewModel.selectRotation].id
                }
            }
        }
    }
    func updateUserInfo(viewModel:ProfileViewController.ViewModel,image:UIImage,finish:@escaping () -> Void){
        if !viewModel.picurl.isEmpty{
            APIUser.updateUserInfo(phoneno: viewModel.phoneno, nickname: viewModel.nickname, finish: {(success) in
                BackUser.getInstance().getUserInfo {}
                finish()
            })
        }else{
            APIUser.uploadProfilePic(image: image, key: viewModel.id, finish: {(success) in
                Helper.saveLocalImage(image: image, id: viewModel.id,success:{
                    finish()
                })
            })
            APIUser.updateUserInfo(phoneno: viewModel.phoneno, nickname: viewModel.nickname, finish: {(success) in
                BackUser.getInstance().getUserInfo {}
            })
        }
    }
    func getMyRank(finish:@escaping (_ response:NSDictionary)->Void){
        APIUser.getRank(success: {(success) in
            var rank = [String:Int]()
            if let content = success.value(forKey: "content") as? NSDictionary{
                if let yourRank = content.value(forKey: "yourRank") as? Int{
                    rank["yourRank"] = yourRank
                }
                if let noStudent = content.value(forKey: "noStudents") as? Int{
                    rank["noStudent"] = noStudent
                }
                finish(rank as NSDictionary)
            }
        })
    }
    func get() -> User?{
        return try! Realm().objects(User.self).first
    }
    func getPerson(id:String) -> Person?{
        return try! Realm().objects(Person.self).filter("id == %@",id).first
    }
    func getDepartment(id:String) ->Department?{
        return try! Realm().objects(Department.self).filter("id == %@",id).first
    }
    func getHospital(id:String) ->Hospital?{
        return try! Realm().objects(Hospital.self).filter("id == %@",id).first
    }
    func getHospital(name:String) ->Hospital?{
        return try! Realm().objects(Hospital.self).filter("name == %@",name).first
    }
    func post(user:User){
        try! Realm().write {
            try! Realm().add(user)
        }
        
    }
    func list() -> Results<User>{
        return try! Realm().objects(User.self)
    }
    func listHospital() -> Results<Hospital>{
        return try! Realm().objects(Hospital.self)
    }
    func removeAll(){
        try! Realm().write {
            try! Realm().deleteAll()
        }
    }
}
