//
//  QuestAddViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 16/5/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit
import MapKit
class QuestAddViewController: UIViewController {
//Route
    var task = Task()
    @IBOutlet weak var lb_task_title: UILabel!
    @IBOutlet weak var lb_task_des: UILabel!
    @IBOutlet weak var lb_task_date: UILabel!
    @IBOutlet weak var lb_task_location: UILabel!
    @IBOutlet weak var tf_verification: UITextField!
    
    @IBAction func btn_cancel_action(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btn_done_action(_ sender: UIBarButtonItem) {
        let view = Helper.showLoading(sender: self)
        APIRotation.updateTaskSign(viewModel: self.viewModel, finish: {(success) in
            view.dismiss(animated:false, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }, fail: {(error) in
            view.dismiss(animated:false, completion: nil)
            Helper.addAlert(sender: self, title: "FAIL", message: "Need verification")
        })
    }
    @IBAction func tf_passcode_change(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }
        if self.limitTextfieldSize(textField: sender, maxSize: 6){
            self.viewModel.verification = text
        }
    }
    var viewModel = ViewModel(){
        didSet{
            if let task = viewModel.task{
                lb_task_title.watch(subject: task.name)
                lb_task_des.watch(subject: task.des)
                lb_task_date.watch(subject: task.datetime?.convertToStringOnlyDate() ?? "")
                lb_task_location.watch(subject: task.place)
                tf_verification.watch(subject: viewModel.verification)
            }
        }
    }
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    func initMap(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
    }
    func limitTextfieldSize(textField:UITextField,maxSize:Int) ->Bool{
        if textField.text!.characters.count > maxSize{
            textField.deleteBackward()
            return false
        }
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTask()
        self.initMap()
    }
    
}
extension QuestAddViewController{
    struct ViewModel {
        var task : Task?
        var verification : String = ""
        var latitude : Double = 0.0
        var longitude : Double = 0.0
    }
    func initTask(){
        self.viewModel.task = task
    }
}
extension QuestAddViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { currentLocation = locations.last }
        
        if currentLocation == nil {
            // Zoom to user location
            if let userLocation = locations.last {
                let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 2000, 2000)
                var yourLocation = MKPointAnnotation()
                yourLocation.coordinate.latitude = userLocation.coordinate.latitude
                yourLocation.coordinate.longitude = userLocation.coordinate.longitude
                self.viewModel.latitude = userLocation.coordinate.latitude
                self.viewModel.longitude = userLocation.coordinate.longitude
                yourLocation.title = "Your Location"
            }
        }
    }
    
}
