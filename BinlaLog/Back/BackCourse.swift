//
//  BackCourse.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/11/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class BackCourse{
    static func getInstance() ->BackCourse{
        return BackCourse()
    }
    func loadCourse(dict:NSDictionary){
        try! Realm().write {
            if let content = dict.value(forKey: "course") as? NSDictionary{
                var course = Course()
                if let id = content.value(forKey: "id") as? String{
                    course.id = id
                    if self.get(id: id) != nil{
                        course = self.get(id: id)!
                    }
                }
                if let collegeyear = content.value(forKey: "collegeyear") as? Int{
                    course.collegeyear = collegeyear
                }
                if let coursecode = content.value(forKey: "coursecode") as? String{
                    course.coursecode = coursecode
                }
                if let coursename_abbr = content.value(forKey: "coursename_abbr") as? String{
                    course.coursename_abbr = coursename_abbr
                }
                if let coursename_s = content.value(forKey: "coursename_s") as? String{
                    course.coursename_s = coursename_s
                }
                if let departmentid = content.value(forKey: "departmentid") as? String{
                    course.departmentid = departmentid
                }
                if let departmentname = content.value(forKey: "departmentname") as? String{
                    course.departmentname = departmentname
                }
                if let des = content.value(forKey: "description") as? String{
                    course.des = des
                }
                if let picurl = content.value(forKey: "picurl") as? String{
                    course.picurl = picurl
                }
                if let procgroupids = content.value(forKey: "procgroupids") as? NSArray{
                    course.procgroupids.removeAll()
                    for i in 0..<procgroupids.count{
                        if let content = procgroupids[i] as? String{
                            let foreignProc = ForeignProcgroup()
                            foreignProc.procgroupid = content
                            course.procgroupids.append(foreignProc)
                        }
                    }
                }
                if let year = content.value(forKey: "year") as? Int{
                    course.year = year
                }
                if self.get(id: course.id) == nil{
                    self.post(object: course)
                }
            }
        }
    }
    func get(id:String) -> Course?{
        return try! Realm().objects(Course.self).filter("id == %@",id).first
    }
    func post(object:Object){
        try! Realm().add(object)
    }
}
