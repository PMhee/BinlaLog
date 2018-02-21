//
//  ProfileViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 31/1/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var tf_nickname: UITextField!
    @IBOutlet weak var tf_phoneno: UITextField!
    @IBAction func tf_nickname_change(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }
        self.viewModel.nickname = text
    }
    @IBAction func tf_phoneno_change(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }
        self.viewModel.phoneno = text
    }
    @IBAction func btn_change_iamge_action(_ sender: UIButton) {
        Helper.ImagePicker(view: self, sender: sender)
    }
    @IBAction func btn_save_action(_ sender: UIBarButtonItem) {
        Helper.showLoading(sender: self)
        BackUser.getInstance().updateUserInfo(viewModel: self.viewModel, image: self.img_profile.image ?? UIImage(), finish: {
            self.dismiss(animated: false, completion: nil)
            self.navigationController?.popViewController(animated: false)
        })
    }
    
    @IBOutlet weak var vw_top: UIView!
    var viewModel = ViewModel(){
        didSet{
            self.lb_name.watch(subject: self.viewModel.name)
            self.tf_nickname.watch(subject: self.viewModel.nickname)
            self.tf_phoneno.watch(subject: self.viewModel.phoneno)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.initUser()
        self.initViewModel()
    }
    func setUI(){
        self.vw_top.backgroundColor = Constant().getColorMain()
    }
}
extension ProfileViewController{
    struct ViewModel {
        var id : String = ""
        var name : String = ""
        var nickname : String = ""
        var phoneno : String = ""
        var studentid : String = ""
        var picurl : String = ""
    }
    func initUser(){
        BackUser.getInstance().getUserInfo {
            self.initViewModel()
            Helper.loadLocalImage(id: self.viewModel.id, success: {(image) in
                self.img_profile.image = image
            })
        }
        Helper.loadLocalImage(id: BackUser.getInstance().get()!.id, success: {(image) in
            self.img_profile.image = image
        })
    }
    func initViewModel(){
        if let user = BackUser.getInstance().get(){
            self.viewModel.id = user.id
            self.viewModel.name = user.firstname + " " + user.lastname
            self.viewModel.nickname = user.nickname
            self.viewModel.phoneno = user.phoneno
            self.viewModel.studentid = user.studentid
            self.viewModel.picurl = user.picurl
        }
    }
}
extension ProfileViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let img = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.img_profile.image = img
        self.viewModel.picurl = ""
        self.dismiss(animated: true, completion: nil)
    }
}
