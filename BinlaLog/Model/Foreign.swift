//
//  Foreign.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/10/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//
import RealmSwift
import Foundation
class ForeignRotation:Object{
    @objc dynamic var rotationid : String = ""
}
class ForeignCourse:Object{
    @objc dynamic var courseid : String = ""
}
class ForeignDiagnosis:Object{
    @objc dynamic var diagnosisid : String = ""
}
class ForeignDisease:Object{
    @objc dynamic var diseaseid : String = ""
}
class ForeignSymptom:Object{
    @objc dynamic var symptomid : String = ""
}
class ForeignProcgroup:Object{
    @objc dynamic var procgroupid : String = ""
}
class ForeignDepartment:Object{
    @objc dynamic var departmentid : String = ""
}
class ForeignLogbook:Object{
    @objc dynamic var logbookid : String = ""
}
class ForeignProcedure:Object{
    @objc dynamic var procedureid : String = ""
}
class ForeignPatientcare:Object{
    @objc dynamic var patientcareid : String = ""
}
class ForeignTask:Object{
    @objc dynamic var taskid : String = ""
}
