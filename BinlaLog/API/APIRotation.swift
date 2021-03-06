//
//  APIRotation.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/10/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
class APIRotation:API{
    static func getCurrentRotation(finish: @escaping (_ response: NSDictionary) -> Void,error: @escaping () -> Void){
        let parameter = ["data":"true"]
        self.request(urlType: .service, httpMethod: .get, path: "rotation/current/", parameter: parameter, success: {(success) in
            finish(success)
        }, failure: {(fail) in
            error()
        })
    }
    static func listRecentRotation(finish: @escaping (_ response: NSDictionary) -> Void){
        let parameter = ["data":"true"]
        self.request(urlType: .service, httpMethod: .get, path: "rotation/passed/", parameter: parameter, success: {(success) in
            finish(success)
        }, failure: {(error) in})
    }
    static func listGrUpdatedPatientCare(updatetime:String,rotationid:String,finish: @escaping (_ response: NSDictionary) -> Void){
        let parameter = ["data":"true","after":updatetime]
        self.request(urlType: .service, httpMethod: .get, path: "rotation/id/\(rotationid)/logbook/patientcare/list/", parameter: parameter, success: {(success) in
            finish(success)
        }, failure: {(error) in})
    }
    static func listUpdatedLogbook(updatetime:String,rotationid:String,finish: @escaping (_ response: NSDictionary) -> Void){
        let parameter = ["data":"true","after":updatetime]
        self.request(urlType: .service, httpMethod: .get, path: "rotation/id/\(rotationid)/logbook/procedure/list/", parameter: parameter, success: {(success) in
            finish(success)
        }, failure: {(error) in})
    }
    static func listQuest(courseid:String,finish: @escaping (_ response: NSDictionary) -> Void){
        self.request(urlType: .service, httpMethod: .get, path: "course/\(courseid)/quest/list", parameter: [:], success: {(success) in
            finish(success)
        }, failure: {(error) in})
    }
    static func deleteLogbook(logbookid:String,finish: @escaping (_ response: NSDictionary) -> Void){
        self.request(urlType: .service, httpMethod: .delete, path: "logbook/procedure/id/\(logbookid)", parameter: [:], success: {(success) in
            finish(success)
        }, failure: {(error) in})
    }
    static func deletePatient(patientid:String,finish: @escaping (_ response: NSDictionary) -> Void){
        self.request(urlType: .service, httpMethod: .delete, path: "logbook/patientcare/id/\(patientid)", parameter: [:], success: {(success) in
            finish(success)
        }, failure: {(error) in})
    }
    static func updateTaskSign(viewModel:QuestAddViewController.ViewModel,finish: @escaping (_ response:NSDictionary) -> Void,fail: @escaping  (_ error: String) -> Void){
        let parameter = ["location":[viewModel.longitude,viewModel.latitude],"verifyCode":viewModel.verification,"donetime":Date().convertToServer()] as [String : Any]
            self.request(urlType: .service, httpMethod: .post, path: "logbook/quest/\(viewModel.task?.questid ?? "")/task/sign/\(viewModel.task?.id ?? "")", parameter: parameter, success: {(success) in
                finish(success)
            }, failure: {(error) in
                print(error)
                fail("")
            })
    }
    static func updateTaskProcedure(logbookid:String,viewModel:ProcedureAddViewController.ViewModel,finish: @escaping (_ response:NSDictionary) -> Void,fail: @escaping  (_ error: String) -> Void){
        let parameter = ["location":[viewModel.longitude,viewModel.latitude],"verifyCode":viewModel.verification,"donetime":Date().convertToServer(),"logProcedureId":logbookid] as [String : Any]
        print(parameter)
        self.request(urlType: .service, httpMethod: .post, path: "logbook/quest/\(viewModel.questId)/task/logbook/procedure/\(viewModel.taskId)", parameter: parameter, success: {(success) in
            finish(success)
        }, failure: {(error) in
            print(error)
            fail("")
        })
    }
    static func updatePatientCare(name:String,patientcareid:String,HN:String,symptomid:[String],dx:[String],diagnosisid:[String],diseaseid:[String],location:String,starttime:String,endtime:String,rotationid:String,latitude:Double,longitude:Double,patienttype:Int,verification:String,note:String,hospitalid:String,finish: @escaping (_ response:NSDictionary) -> Void){
        let parameter = ["name":name,"HN":HN,"symptomid": symptomid,"dx":dx,"diagnosisid":diagnosisid,"location":[longitude,latitude],"diseaseid":diseaseid,"starttime":starttime,"endtime":endtime,"rotationid":rotationid,"patienttype":patienttype,"verifycode":verification,"note":note,"hospitalid":hospitalid] as [String:Any]
        if patientcareid == ""{
            self.request(urlType: .service, httpMethod: .post, path: "logbook/patientcare", parameter: parameter, success: {(success) in
                
                finish(success)
            }, failure: {(error) in
                
            })
        }else{
            self.request(urlType: .service, httpMethod: .put, path: "logbook/patientcare/id/\(patientcareid)", parameter: parameter, success: {(success) in
                finish(success)
            }, failure: {(error) in
                
            })
        }
        
        
    }
    static func updateLogbook(logbookid:String,rotationid:String,HN:String,procedureid:[String],feeling:Int,location:String,patienttype:Int,logtype:Int,donetime:String,deviceid:String,verification:String,latitude:Double,longitude:Double,note:String,hospitalid:String,feelingMessage:String,finish: @escaping (_ response:NSDictionary) -> Void,fail: @escaping  (_ error: String) -> Void){
        
        let parameter = ["rotationid":rotationid,"HN":HN,"procedureids":procedureid,"location":[longitude,latitude],"patienttype":patienttype,"performance":feeling,"logtype":logtype,"donetime":donetime,"verifycode":verification,"note":note,"hospitalid":hospitalid,"feelingMsg":feelingMessage] as [String : Any]
        if logbookid == ""{
            self.request(urlType: .service, httpMethod: .post, path: "logbook/procedure", parameter: parameter, success: {(success) in
                finish(success)
            }, failure: {(error) in
                fail("")
            })
        }else{
            self.request(urlType: .service, httpMethod: .put, path: "logbook/procedure/id/\(logbookid)", parameter: parameter, success: {(success) in
                finish(success)
            }, failure: {(error) in
                fail("")
            })
        }
    }
    
}
