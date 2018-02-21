//
//  BackPatient.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/9/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class BackPatient:Back{
    
    static func getInstance() ->BackPatient{
        return BackPatient()
    }
    //Symptom
    func loadSymptom(symptom:NSDictionary) ->String{
        //searchkey still bug because did not get object form db
        var symp = ""
        try! Realm().write {
            var backsymptom = Symptom()
            if let id = symptom.value(forKey: "id") as? String{
                backsymptom.id = id
                symp = id
                if self.getSymptom(id: id) != nil{
                    backsymptom = self.getSymptom(id: id)!
                }
            }
            if let description = symptom.value(forKey: "description") as? String{
                backsymptom.des = description
            }
            if let name = symptom.value(forKey: "name") as? String{
                backsymptom.name = name
            }
            if let score = symptom.value(forKey: "score") as? Double{
                backsymptom.score = score
            }
            if let searhKey = symptom.value(forKey: "searchKey") as? NSArray{
                for i in 0..<searhKey.count{
                    if let key = searhKey[i] as? String{
                        let backKey = SymptomSearchKey()
                        backKey.key = key
                        backsymptom.searchKey.append(backKey)
                    }
                }
            }
            if let visible = symptom.value(forKey: "visible") as? Int{
                backsymptom.visible = visible
            }
            if self.getSymptom(id: backsymptom.id) == nil{
                self.post(object: backsymptom)
            }
        }
        return symp
    }
    func searchSymptom(){
        APIPatient.listSymptom(finish: {(success) in
            if let json = success.value(forKey: "content") as? NSDictionary{
                if let array = json.value(forKey: "data") as? NSArray{
                    for i in 0..<array.count{
                        if let content = array[i] as? NSDictionary{
                            self.loadSymptom(symptom: content)
                        }
                    }
                }
            }
        }, fail: {(error) in
            
        })
    }
    func getSymptom(key:String) -> Symptom?{
        return try! Realm().objects(Symptom.self).filter("name == %@",key).first
    }
    func getSymptom(id:String) -> Symptom?{
        return try! Realm().objects(Symptom.self).filter("id == %@",id).first
    }
    func listSymptom(key:String) -> Results<Symptom>{
        return try! Realm().objects(Symptom.self).filter("ANY searchKey.key contains[c] %@ OR name contains[c] %@ OR des contains[c] %@",key,key,key)
    }
    //Diagnosis
    func searchDiagnosis(key:String,finish: @escaping () -> Void){
        APIPatient.listDiagnosis(keyword: key, finish: {(success) in
            if let json = success.value(forKey: "content") as? NSDictionary{
                if let array = json.value(forKey: "data") as? NSArray{
                    for i in 0..<array.count{
                        if let content = array[i] as? NSDictionary{
                            self.loadDiagnosis(diagnosis: content)
                            if let disease = content.value(forKey: "disease") as? NSDictionary{
                                self.loadDisease(disease: disease)
                            }
                            
                        }
                    }
                    finish()
                }
            }
        }, fail: {(error) in})
    }
    func loadDiagnosis(diagnosis:NSDictionary) ->String{
        var diag = ""
        try! Realm().write {
            var backdiagnosis = Diagnosis()
            if let id = diagnosis.value(forKey: "id") as? String{
                backdiagnosis.id = id
                diag = id
                if self.getDiagnosis(id: id) != nil{
                    backdiagnosis = self.getDiagnosis(id: id)!
                }
            }
            if let description = diagnosis.value(forKey: "description") as? String{
                backdiagnosis.des = description
            }
            if let diseasegroup = diagnosis.value(forKey: "diseasegroup") as? String{
                backdiagnosis.diseasegroup = diseasegroup
            }
            if let diseaseid = diagnosis.value(forKey: "diseaseid") as? String{
                backdiagnosis.diseaseid = diseaseid
            }
            if let name = diagnosis.value(forKey: "name") as? String{
                backdiagnosis.name = name
            }
            if let searchKey = diagnosis.value(forKey: "searchkey") as? NSArray{
                backdiagnosis.searchKey.removeAll()
                for i in 0..<searchKey.count{
                    if let key = searchKey[i] as? String{
                        let backkey = DiagnosisSearchKey()
                        backkey.key = key
                        backdiagnosis.searchKey.append(backkey)
                    }
                }
            }
            if self.getDiagnosis(id: backdiagnosis.id) == nil{
                self.post(object: backdiagnosis)
            }
        }
        return diag
    }
    func getDiagnosis(key:String) ->Diagnosis?{
        return try! Realm().objects(Diagnosis.self).filter("name == %@",key).first
    }
    func getDiagnosis(id:String) ->Diagnosis?{
        return try! Realm().objects(Diagnosis.self).filter("id == %@",id).first
    }
    func listDiagnosis(key:String) -> Results<Diagnosis>{
        return try! Realm().objects(Diagnosis.self).filter("ANY searchKey.key contains[c] %@ OR name contains[c] %@ OR des contains[c] %@",key,key,key)
    }
    //Disease
    func loadDisease(disease:NSDictionary) ->String{
        var dise = ""
        try! Realm().write {
            var backdisease = Disease()
            if let id = disease.value(forKey: "id") as? String{
                backdisease.id = id
                dise = id
                if self.getDisease(id: id) != nil{
                    backdisease = self.getDisease(id: id)!
                }
            }
            if let description = disease.value(forKey: "description") as? String{
                backdisease.des = description
            }
            if let name = disease.value(forKey: "name") as? String{
                backdisease.name = name
            }
            if let searchkey = disease.value(forKey: "searchkey") as? NSArray{
                backdisease.searchKey.removeAll()
                for i in 0..<searchkey.count{
                    if let key = searchkey[i] as? String{
                        let backkey = DiseaseSearchKey()
                        backkey.key = key
                        backdisease.searchKey.append(backkey)
                    }
                }
            }
            if let visible = disease.value(forKey: "visible") as? Int{
                backdisease.visible = visible
            }
            if self.getDisease(id: backdisease.id) == nil{
                self.post(object: backdisease)
            }
        }
        return dise
    }
    func searchDisease(){
        APIPatient.listDisease(finish: {(success) in
            if let json = success.value(forKey: "content") as? NSDictionary{
                if let array = json.value(forKey: "data") as? NSArray{
                    for i in 0..<array.count{
                        if let content = array[i] as? NSDictionary{
                            self.loadDisease(disease: content)
                        }
                    }
                }
            }
        }, fail: {(error) in
            
        })
    }
    func getDisease(key:String) -> Disease?{
        return try! Realm().objects(Disease.self).filter("name == %@",key).first
    }
    func getDisease(id:String) ->Disease?{
        return try! Realm().objects(Disease.self).filter("id == %@",id).first
    }
    func listDisease(key:String) -> Results<Disease>{
        return try! Realm().objects(Disease.self).filter("ANY searchKey.key contains[c] %@ OR name contains[c] %@ OR des contains[c] %@",key,key,key)
    }
    
    
    
    func get() {
        
    }
    func delete() {
        
    }
    func put() {
        
    }
    func list(){
        
    }
}
