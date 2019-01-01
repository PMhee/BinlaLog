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
                //                if let procgroupids = content.value(forKey: "procgroupids") as? NSArray{
                //                    course.procgroupids.removeAll()
                //                    for i in 0..<procgroupids.count{
                //                        if let content = procgroupids[i] as? String{
                //                            let foreignProc = ForeignProcgroup()
                //                            foreignProc.procgroupid = content
                //                            course.procgroupids.append(foreignProc)
                //                        }
                //                    }
                //                }
                if let year = content.value(forKey: "year") as? Int{
                    course.year = year
                }
                if self.get(id: course.id) == nil{
                    self.post(object: course)
                }
            }
        }
    }
    func loadProcgroup(courseid:String,procgroup:NSArray){
        try! Realm().write {
            var course = Course()
            if self.get(id: courseid) != nil{
                course = self.get(id: courseid)!
            }
            course.procgroupids.removeAll()
            for i in 0..<procgroup.count{
                if let content = procgroup[i] as? NSDictionary{
                    let foreignProc = ForeignProcgroup()
                    foreignProc.procgroupid = content.value(forKey: "id") as! String
                    course.procgroupids.append(foreignProc)
                }
            }
        }
    }
    func enumQuest(courseid:String,finish: @escaping () -> Void){
        APIRotation.listQuest(courseid: courseid, finish: {(json) in
            if let content = json.value(forKey: "content") as? NSDictionary{
                if let data = content.value(forKey: "data") as? NSArray{
                    for i in 0..<data.count{
                        if let dic = data[i] as? NSDictionary{
                            self.loadQuest(content: dic)
                        }
                    }
                    finish()
                }
            }
        })
    }
    func loadQuest(content:NSDictionary){
        try! Realm().write{
            var quest = Quest()
            if let id = content.value(forKey: "id") as? String{
                quest.id = id
                if self.getQuest(id: id) != nil{
                    quest = self.getQuest(id: id)!
                }
            }
            if let courseid = content.value(forKey: "courseId") as? String{
                quest.courseid = courseid
            }
            if let des = content.value(forKey: "description") as? String{
                quest.des = des
            }
            if let name = content.value(forKey: "name") as? String{
                quest.name = name
            }
            if let score = content.value(forKey: "score") as? Double{
                quest.score = score
            }
            if let updatetime = content.value(forKey: "updatetime") as? String{
                quest.updatetime = updatetime.convertToDate()
            }
            quest.task.removeAll()
            if let tasks = content.value(forKey: "tasks") as? NSArray{
                for i in 0..<tasks.count{
                    if let task = tasks[i] as? NSDictionary{
                        if let id = task.value(forKey: "id") as? String{
                            let foreign = ForeignTask()
                            foreign.taskid = id
                            quest.task.append(foreign)
                        }
                    }
                }
            }
            if self.getQuest(id: quest.id) == nil {
                try! Realm().add(quest)
            }
        }
        if let tasks = content.value(forKey: "tasks") as? NSArray{
            for i in 0..<tasks.count{
                if let task = tasks[i] as? NSDictionary{
                    self.loadTask(content: task)
                }
            }
        }
    }
    func loadTask(content:NSDictionary){
        var task = Task()
        try! Realm().write {
            if let id = content.value(forKey: "id") as? String{
                task.id = id
                if self.getTask(id: id) != nil {
                    task = self.getTask(id: id)!
                }
            }
            if let datetime = content.value(forKey: "datetime") as? String{
                task.datetime = datetime.convertToDate()
            }
            if let des = content.value(forKey: "description") as? String{
                task.des = des
            }
            if let isNeedVerify = content.value(forKey: "isNeedVerify") as? Bool{
                task.isNeedVerify = isNeedVerify
            }
            if let name = content.value(forKey: "name") as? String{
                task.name = name
            }
            if let noLog = content.value(forKey: "noLog") as? Int{
                task.noLog = noLog
            }
            if let place = content.value(forKey: "place") as? String{
                task.place = place
            }
            if let questId = content.value(forKey: "questId") as? String{
                task.questid = questId
            }
            if let taskNo = content.value(forKey: "taskNo") as? Int{
                task.taskNo = taskNo
            }
            if let type = content.value(forKey: "type") as? Int{
                task.type = type
            }
            if let updatetime = content.value(forKey: "updatetime") as? String{
                task.updatetime = updatetime.convertToDate()
            }
            task.taskLogProcedure.removeAll()
            if let procedureIds = content.value(forKey: "procedureIds") as? NSArray{
                for i in 0..<procedureIds.count{
                    if let id = procedureIds[i] as? String{
                        let foreign = ForeignProcedure()
                        foreign.procedureid = id
                        task.taskLogProcedure.append(foreign)
                    }
                }
            }
            if self.getTask(id: task.id) == nil {
                try! Realm().add(task)
            }
        }
        if let procedures = content.value(forKey: "procedures") as? NSArray{
            for i in 0..<procedures.count{
                if let pro = procedures[i] as? NSDictionary{
                    BackProcedure.getInstance().loadProcedure(content: pro)
                }
            }
        }
    }
    func get(id:String) -> Course?{
        return try! Realm().objects(Course.self).filter("id == %@",id).first
    }
    func getQuest(id:String) -> Quest?{
        return try! Realm().objects(Quest.self).filter("id == %@",id).first
    }
    func getTask(id:String) -> Task?{
        return try! Realm().objects(Task.self).filter("id == %@",id).first
    }
    func list() -> Results<Course>{
        return try! Realm().objects(Course.self)
    }
    func listQuest() -> Results<Quest>{
        return try! Realm().objects(Quest.self)
    }
    func post(object:Object){
        try! Realm().add(object)
    }
}
