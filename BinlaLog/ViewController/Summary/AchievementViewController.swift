//
//  AchievementViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 5/2/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class AchievementViewController: UIViewController,UISearchResultsUpdating {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cons_collection_height: NSLayoutConstraint!
    @IBAction func btn_cancel_action(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    //Variable
    var index = 0
    var viewModel = ViewModel(){
        didSet{
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.initProcedure()
        self.initLogbook()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    func setUI(){
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            let searchController = UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = self
            searchController.dimsBackgroundDuringPresentation = false
            searchController.searchBar.barTintColor = UIColor.white
            searchController.searchBar.backgroundColor = UIColor.clear
            searchController.searchBar.tintColor = UIColor.white
            if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
                if let backgroundview = textfield.subviews.first {
                    backgroundview.backgroundColor = UIColor.white
                    backgroundview.layer.cornerRadius = 10;
                    backgroundview.clipsToBounds = true;
                }
            }
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // Fallback on earlier versions
        }
    }
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        self.doSearchProcedure(key: text)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "view"{
            if let des = segue.destination as? SummaryProcedureViewController{
                des.procedureid = self.viewModel.procedures![self.index].id
                des.isEditing = false
            }
        }
    }
}
extension AchievementViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let vw_poly = cell.viewWithTag(1)
        let img_proc = cell.viewWithTag(2) as! UIImageView
        let lb_proc = cell.viewWithTag(3) as! UILabel
        let lb_proc_name = cell.viewWithTag(4) as! UILabel
        let maskLayer = CAShapeLayer()
        maskLayer.frame = (vw_poly?.bounds)!
        maskLayer.path = self.roundedPolygonPath(rect: CGRect(x:0,y:0,width:vw_poly!.frame.width,height:vw_poly!.frame.height), lineWidth: 1, sides: 6, cornerRadius: 2).cgPath
        vw_poly?.layer.mask = maskLayer
        lb_proc.text = "\(BackRotation.getInstance().listLogbook(procedureid: self.viewModel.procedures![indexPath.row].id).count)"
        switch self.viewModel.procedures![indexPath.row].proctype {
        case 1:vw_poly?.backgroundColor = Constant().getLvEasy()
        case 2:vw_poly?.backgroundColor = Constant().getLvMedium()
        case 3:vw_poly?.backgroundColor = Constant().getLvHard()
        default:
            vw_poly?.backgroundColor = UIColor(netHex:0xeeeeee)
        }
        if BackProcedure.getInstance().isAchieve(procedureid: self.viewModel.procedures![indexPath.row].id){
            lb_proc.isHidden = false
        }else{
            vw_poly?.backgroundColor = UIColor(netHex:0xeeeeee)
            lb_proc.isHidden = true
        }
        lb_proc_name.text = self.viewModel.procedures![indexPath.row].name
        img_proc.image = UIImage(named:BackProcedure.getInstance().getGroup(id: self.viewModel.procedures![indexPath.row].proceduregroup)?.picurl ?? "")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.viewModel.procedures == nil{
            return 0
        }else{
            return self.viewModel.procedures!.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.index = indexPath.row
        self.performSegue(withIdentifier: "view", sender: self)
    }
}
extension AchievementViewController{
    struct ViewModel {
        var procedures : Results<Procedure>?
    }
    func doSearchProcedure(key:String){
        self.viewModel.procedures = BackProcedure.getInstance().list(key: key)
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
        self.cons_collection_height.constant = self.collectionView.contentSize.height
    }
    func initProcedure(){
        BackProcedure.getInstance().enumProcedure {
            self.viewModel.procedures = BackProcedure.getInstance().list(key: "").sorted(byKeyPath: "name", ascending: true)
            self.collectionView.reloadData()
            self.collectionView.layoutIfNeeded()
            self.cons_collection_height.constant = self.collectionView.contentSize.height
        }
        self.viewModel.procedures = BackProcedure.getInstance().list(key: "").sorted(byKeyPath: "name", ascending: true)
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
        self.cons_collection_height.constant = self.collectionView.contentSize.height
    }
    func initLogbook(){
        var j = 0
        for i in 0..<BackUser.getInstance().get()!.currentRotation.count{
            BackRotation.getInstance().EnumLogbook(updatetime: BackRotation.getInstance().getLastUpdateTime(rotationid: BackUser.getInstance().get()!.currentRotation[i].rotationid), rotationid: BackUser.getInstance().get()!.currentRotation[i].rotationid, finish: {
                j += 1
                if j == BackUser.getInstance().get()!.currentRotation.count{
                    self.collectionView.reloadData()
                }
            })
        }
        var k = 0
        for i in 0..<BackUser.getInstance().get()!.recentRotation.count{
            BackRotation.getInstance().EnumLogbook(updatetime: BackRotation.getInstance().getLastUpdateTime(rotationid: BackUser.getInstance().get()!.recentRotation[i].rotationid), rotationid: BackUser.getInstance().get()!.recentRotation[i].rotationid, finish: {
                k += 1
                if k == BackUser.getInstance().get()!.recentRotation.count{
                    self.collectionView.reloadData()
                }
            })
        }
    }
    func roundedPolygonPath(rect: CGRect, lineWidth: CGFloat, sides: NSInteger, cornerRadius: CGFloat, rotationOffset: CGFloat = 0) -> UIBezierPath {
        let path = UIBezierPath()
        let theta: CGFloat = CGFloat(2.0 * M_PI) / CGFloat(sides) // How much to turn at every corner
        let offset: CGFloat = cornerRadius * tan(theta / 2.0)     // Offset from which to start rounding corners
        let width = min(rect.size.width, rect.size.height)        // Width of the square
        let center = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)
        // Radius of the circle that encircles the polygon
        // Notice that the radius is adjusted for the corners, that way the largest outer
        // dimension of the resulting shape is always exactly the width - linewidth
        let radius = (width - lineWidth + cornerRadius - (cos(theta) * cornerRadius)) / 2.0
        // Start drawing at a point, which by default is at the right hand edge
        // but can be offset
        var angle = CGFloat(rotationOffset)
        let corner = CGPoint(x:center.x + (radius - cornerRadius) * cos(angle),y:center.y + (radius - cornerRadius) * sin(angle))
        path.move(to: CGPoint(x:corner.x + cornerRadius * cos(angle + theta), y:corner.y + cornerRadius * sin(angle + theta)))
        for _ in 0..<sides {
            angle += theta
            let corner = CGPoint(x:center.x + (radius - cornerRadius) * cos(angle),y: center.y + (radius - cornerRadius) * sin(angle))
            let tip = CGPoint(x:center.x + radius * cos(angle), y:center.y + radius * sin(angle))
            let start = CGPoint(x:corner.x + cornerRadius * cos(angle - theta), y:corner.y + cornerRadius * sin(angle - theta))
            let end = CGPoint(x:corner.x + cornerRadius * cos(angle + theta), y:corner.y + cornerRadius * sin(angle + theta))
            path.addLine(to: start)
            path.addQuadCurve(to: end, controlPoint: tip)
        }
        path.close()
        // Move the path to the correct origins
        let bounds = path.bounds
        let transform = CGAffineTransform(translationX: -bounds.origin.x + rect.origin.x + lineWidth / 2.0, y: -bounds.origin.y + rect.origin.y + lineWidth / 2.0)
        path.apply(transform)
        
        return path
    }
}
