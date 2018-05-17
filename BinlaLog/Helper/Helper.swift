//
//  Helper.swift
//  BinlaLog
//
//  Created by Tanakorn on 12/25/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import UIKit
fileprivate var ActivityIndicatorViewAssociativeKey = "ActivityIndicatorViewAssociativeKey"
extension UIFont{
    var isBold: Bool
    {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    
    var isItalic: Bool
    {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
    
    func setBold() -> UIFont
    {
        if(isBold)
        {
            return self
        }
        else
        {
            var fontAtrAry = fontDescriptor.symbolicTraits
            fontAtrAry.insert([.traitBold])
            let fontAtrDetails = fontDescriptor.withSymbolicTraits(fontAtrAry)
            return UIFont(descriptor: fontAtrDetails!, size: pointSize)
        }
    }
    
    func setItalic()-> UIFont
    {
        if(isItalic)
        {
            return self
        }
        else
        {
            var fontAtrAry = fontDescriptor.symbolicTraits
            fontAtrAry.insert([.traitItalic])
            let fontAtrDetails = fontDescriptor.withSymbolicTraits(fontAtrAry)
            return UIFont(descriptor: fontAtrDetails!, size: pointSize)
        }
    }
    func desetBold() -> UIFont
    {
        if(!isBold)
        {
            return self
        }
        else
        {
            var fontAtrAry = fontDescriptor.symbolicTraits
            fontAtrAry.remove([.traitBold])
            let fontAtrDetails = fontDescriptor.withSymbolicTraits(fontAtrAry)
            return UIFont(descriptor: fontAtrDetails!, size: pointSize)
        }
    }
    
    func desetItalic()-> UIFont
    {
        if(!isItalic)
        {
            return self
        }
        else
        {
            var fontAtrAry = fontDescriptor.symbolicTraits
            fontAtrAry.remove([.traitItalic])
            let fontAtrDetails = fontDescriptor.withSymbolicTraits(fontAtrAry)
            return UIFont(descriptor: fontAtrDetails!, size: pointSize)
        }
    }
}
public extension UIView {
    var activityIndicatorView: UIActivityIndicatorView {
        get {
            if let activityIndicatorView = getAssociatedObject(&ActivityIndicatorViewAssociativeKey) as? UIActivityIndicatorView {
                return activityIndicatorView
            } else {
                let activityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                activityIndicatorView.activityIndicatorViewStyle = .gray
                activityIndicatorView.color = .gray
                activityIndicatorView.center = center
                activityIndicatorView.hidesWhenStopped = true
                addSubview(activityIndicatorView)
                
                setAssociatedObject(activityIndicatorView, associativeKey: &ActivityIndicatorViewAssociativeKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return activityIndicatorView
            }
        }
        
        set {
            addSubview(newValue)
            setAssociatedObject(newValue, associativeKey:&ActivityIndicatorViewAssociativeKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
extension UIScrollView {
    
    var isAtTop: Bool {
        return contentOffset.y + 100 <= verticalOffsetForTop
    }
    
    var isAtBottom: Bool {
        return contentOffset.y - 100 >= verticalOffsetForBottom
    }
    
    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }
    
    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
    
}
public extension NSObject {
    func setAssociatedObject(_ value: AnyObject?, associativeKey: UnsafeRawPointer, policy: objc_AssociationPolicy) {
        if let valueAsAnyObject = value {
            objc_setAssociatedObject(self, associativeKey, valueAsAnyObject, policy)
        }
    }
    
    func getAssociatedObject(_ associativeKey: UnsafeRawPointer) -> Any? {
        guard let valueAsType = objc_getAssociatedObject(self, associativeKey) else {
            return nil
        }
        return valueAsType
    }
}
extension UITableView{
    func reload() {
        
        let contentOffset = self.contentOffset
        self.reloadData()
        self.layoutIfNeeded()
        self.setContentOffset(contentOffset, animated: false)
        
    }
}
public extension UISearchBar {
    
    public func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
}
extension UINavigationItem{
    override open func awakeFromNib() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.backBarButtonItem = backItem
    }
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
extension UIColor {
    convenience init(_ hex: UInt) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension Date{
    func convertToString() ->String{
        let format = DateFormatter()
        format.dateStyle = .medium
        format.timeStyle = .medium
        format.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        return format.string(from: self)
    }
    func convertToStringOnlyDate() ->String{
        let format = DateFormatter()
        format.dateStyle = .medium
        format.timeStyle = .none
        format.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        return format.string(from: self)
    }
    func convertToServer() ->String{
        let format = DateFormatter()
        format.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        format.dateFormat = Constant().getDateFormat()
        return format.string(from: self)
    }
    func year(from date:Date) -> Int{
        return Calendar.current.dateComponents([.year], from: date).year ?? 0
    }
    func month(from date:Date) -> String{
        let dateFormatter: DateFormatter = DateFormatter()
        let months = dateFormatter.shortMonthSymbols
        let monthSymbol = months?[(Calendar.current.dateComponents([.month], from: date).month)!-1]
        return monthSymbol!
    }
    func day(from date:Date) -> Int{
        return Calendar.current.dateComponents([.day], from: date).day ?? 0
    }
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 {
            if years(from: date) == 1{
                return "\(years(from: date)) year"
            }
            return "\(years(from: date)) years"
        }
        if months(from: date)  > 0 {
            if months(from: date) == 1{
                return "\(months(from: date)) month"
            }
            return "\(months(from: date)) months"
        }
        if days(from: date)    > 0 {
            if days(from:date) == 1{
                return "\(days(from: date)) day"
            }
            return "\(days(from: date)) days"
        }
        if hours(from: date)   > 0 {
            if hours(from:date) == 1{
                return "\(hours(from: date)) hr"
            }
            return "\(hours(from: date)) hrs"
        }
        if minutes(from: date) > 0 {
            if minutes(from: date) == 1{
                return "\(minutes(from: date)) min"
            }
            return "\(minutes(from: date)) mins" }
        if seconds(from: date) > 0 { return "Just now" }
        return "Just now"
    }
    func recent(from date: Date) -> String {
        let format = DateFormatter()
        format.dateStyle = .medium
        format.timeStyle = .medium
        format.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        if years(from: date)   > 0 {
            return format.string(from:date)
        }
        if days(from: date)    > 0 {
            if days(from:date) < 2{
                return "yesterday"
            }
            return "\(days(from: date)) days ago"
        }
        if hours(from: date)   > 0 {
            if hours(from:date) == 1{
                return "\(hours(from: date)) hr ago"
            }
            return "\(hours(from: date)) hrs ago"
        }
        if minutes(from: date) > 0 {
            if minutes(from: date) == 1{
                return "\(minutes(from: date)) min ago"
            }
            return "\(minutes(from: date)) mins ago" }
        if seconds(from: date) > 0 { return "Just now" }
        return "Just now"
    }
}
extension String{
    func convertToDate() ->Date{
        let format = DateFormatter()
        format.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        format.dateFormat = Constant().getDateFormat()
        return format.date(from: self) ?? Date()
    }
}
extension UIView{
    func shadow(){
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.24
        self.layer.shadowRadius = CGFloat(2)
    }
    func createGradientLayer(colors:[CGColor]) {
        var gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors
        self.layer.addSublayer(gradientLayer)
    }
    func resize(width:CGFloat,height:CGFloat){
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width+width, height: self.frame.height+height)
    }
}
extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
    func subStringOf(c:Character,isStart:Bool=true) ->String{
        let index = self.index(of: c) ?? self.endIndex
        if isStart{
            return String(self[..<index])
        }else{
            return String(self[self.index(after: index)...])
        }
        
    }
}
extension Dictionary where Value:Comparable {
    var sortedByValue:[(Key,Value)] {return Array(self).sorted{$0.1 > $1.1}}
}
extension Dictionary where Key:Comparable {
    var sortedByKey:[(Key,Value)] {return Array(self).sorted{$0.0 < $1.0}}
}
class Helper{
    static func ImagePicker(view:UIViewController,sender:UIButton){
        let actionSheet = UIAlertController(title: "Image Selection", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
            print("Cancel")
        }))
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            action in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                if let viewC = view as? UIImagePickerControllerDelegate & UINavigationControllerDelegate{
                    imagePicker.delegate = viewC
                }
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.allowsEditing = true
                view.present(imagePicker, animated: true, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {
            action in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                if let viewC = view as? UIImagePickerControllerDelegate & UINavigationControllerDelegate{
                    imagePicker.delegate = viewC
                }
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                imagePicker.allowsEditing = false
                view.present(imagePicker, animated: true, completion: nil)
            }
        }))
        actionSheet.popoverPresentationController?.sourceView = view.view
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: view.view.frame.width, y: 0, width: sender.frame.width, height: sender.frame.height)
        view.present(actionSheet, animated: true, completion: nil)
    }
    static func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    static func saveLocalImage(picurl:String,id:String){
        DispatchQueue.global(qos:.background).async {
            if let url = URL(string: picurl) {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        if let data = UIImageJPEGRepresentation(image,1.0) {
                            let file = "\(id)"
                            let filename = self.getDocumentsDirectory().appendingPathComponent(file)
                            try? data.write(to: filename, options: .atomic)
                        }
                    }
                }
            }
        }
    }
    static func saveLocalImage(image:UIImage,id:String){
        DispatchQueue.global(qos:.background).async {
            if let data = UIImageJPEGRepresentation(image,1.0) {
                let file = "\(id)"
                let filename = self.getDocumentsDirectory().appendingPathComponent(file)
                try? data.write(to: filename, options: .atomic)
            }
        }
    }
    static func saveLocalImage(image:UIImage,id:String,success:@escaping () -> Void){
        DispatchQueue.global(qos:.background).async {
            if let data = UIImageJPEGRepresentation(image,1.0) {
                let file = "\(id)"
                let filename = self.getDocumentsDirectory().appendingPathComponent(file)
                try? data.write(to: filename, options: .atomic)
                DispatchQueue.main.async {
                    success()
                }
            }
        }
    }
    static func loadLocalImage(id:String,success: @escaping (_ response: UIImage?) -> Void){
        DispatchQueue.global(qos:.background).async {
            let fileURL = self.getDocumentsDirectory().appendingPathComponent("\(id)")
            do {
                let imageData = try Data(contentsOf: fileURL)
                DispatchQueue.main.async {
                    success(UIImage(data:imageData))
                }
            } catch {
                DispatchQueue.main.async {
                    success(UIImage())
                }
                print("Error loading image : \(error)")
            }
            // Do whatever you want with the image
        }
    }
    static func loadLocalImage(id:String,image:UIImageView){
        DispatchQueue.global(qos:.background).async {
            let fileURL = self.getDocumentsDirectory().appendingPathComponent("\(id)")
            do {
                let imageData = try Data(contentsOf: fileURL)
                DispatchQueue.main.async {
                    image.image = UIImage(data:imageData)
                }
            } catch {
                DispatchQueue.main.async {
                    image.image = UIImage()
                }
                print("Error loading image : \(error)")
            }
        }
    }
    static func loadServerImage(link:String,success: @escaping (_ response: UIImage?) -> Void) {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                if let data = data {
                    success(UIImage(data:data))
                }
            }
        }).resume()
    }
    static func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    static func showFilter(sender:UIViewController){
        let storyboard = UIStoryboard(name: "Helper", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        sender.present(vc, animated: true, completion: nil)
    }
    static func showLoading(sender:UIViewController) -> UIViewController{
        let storyboard = UIStoryboard(name: "Helper", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoadingViewController") as! LoadingViewController
        sender.modalPresentationStyle = .overCurrentContext
        sender.present(vc, animated: false, completion: nil)
        return vc
    }
    static func showDatePicker(sender:UIViewController,date:Date,restrictDate:Date){
        let storyboard = UIStoryboard(name: "Helper", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
        vc.setDate(date: date)
        vc.setRestrictedDate(date: restrictDate)
        sender.modalPresentationStyle = .overCurrentContext
        sender.present(vc, animated: false, completion: nil)
    }
    static func showPicker(sender:UIViewController,arr:[String]){
        let storyboard = UIStoryboard(name: "Helper", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
        vc.arr = arr
        sender.modalPresentationStyle = .overCurrentContext
        sender.present(vc, animated: false, completion: nil)
    }
    static func showEBook(sender:UIViewController,title:String){
        let storyboard = UIStoryboard(name: "Book", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BookViewController") as! UINavigationController
        if let des = vc.topViewController as? BookViewController{
            des.eBookTitle = title
        }
        sender.modalPresentationStyle = .fullScreen
        sender.present(vc, animated: true, completion: nil)
    }
    static func showWarning(sender:UIViewController, text:String){
        let v = UIView(frame:CGRect(x: 0, y: 0, width: sender.view.frame.width, height: 30))
        let lb = UILabel(frame: CGRect(x: v.frame.origin.x, y: v.frame.origin.y, width: v.frame.width  , height: v.frame.height))
        lb.text = text
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = UIColor.white
        lb.textAlignment = NSTextAlignment.center
        v.backgroundColor = UIColor.black
        v.alpha = 1
        v.tag = 99
        lb.tag = 100
        sender.view.addSubview(v)
        sender.view.bringSubview(toFront: v)
        sender.view.addSubview(lb)
        sender.view.bringSubview(toFront: lb)
        self.delay(2){
            let tag = sender.view.viewWithTag(99)
            tag?.removeFromSuperview()
            let t = sender.view.viewWithTag(100)
            t?.removeFromSuperview()
            let tt = sender.view.viewWithTag(98)
            tt?.removeFromSuperview()
        }
    }
    static func addAlert(sender:UIViewController,title:String="",message:String=""){
        let alert = UIAlertController(title: title, message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: {action in
        }))
        sender.present(alert, animated: true, completion: nil)
    }
    static func getSpinner(sender:UIView) ->UIView{
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: sender.bounds.width, height: CGFloat(44))
        return spinner
    }
    static func tableViewLoading(sender:NViewControllerDelegate,tableView:UITableView,offset:CGFloat,isLoading:Bool) ->Bool{
        if tableView.isAtTop{
            tableView.tableHeaderView = self.getSpinner(sender: tableView)
            sender.loadTop {
                tableView.tableHeaderView = nil
            }
            return true
        }else if tableView.isAtBottom{
            tableView.tableFooterView = self.getSpinner(sender: tableView)
            sender.loadBottom {
                tableView.tableFooterView = nil
            }
            return true
        }else{
            return false
        }
    }
    static func generateID() ->String{
        let time = String(Int(NSDate().timeIntervalSince1970), radix: 16, uppercase: false)
        let machine = String(arc4random_uniform(900000) + 100000)
        let pid = String(arc4random_uniform(9000) + 1000)
        let counter = String(arc4random_uniform(900000) + 100000)
        return time + machine + pid + counter
    }
}
