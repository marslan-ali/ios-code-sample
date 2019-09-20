/**
 * Class SendRouteVC.swift
 * @package     Application
 * @author      Arslan Ali
 * @email       marslan.ali@gmail.com
 */


import UIKit
import CoreLocation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

class RouteData: NSObject
{
    var name = String()
    var vehicle = String()
    var distance = String()
    var routine = String()
    var startTime = String()
    var endTime = String()
    var price = String()
    var coordinates = String()
}

class SaveRouteVC: UIViewController,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate
{
    
    
    
    @IBOutlet var startTimeTextField: UITextField!
    
    @IBOutlet var endTimeTextField: UITextField!
    
    
    @IBOutlet var routineTextField: UITextField!
    
    @IBOutlet var distance: UILabel!
    
    @IBOutlet var priceTextField: UITextField!
    
    
    
    
    var routesArray : [String]!
    
    let timePicker = UIDatePicker()
    
    var dropDownPickerView : UIPickerView!
    
    var routineList = ["Daily","Weekly","Weekend"]
    
    var routeName : String!
    var vehicle : String!
    

    // Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.showTimePicker(textField: self.startTimeTextField)
        self.showTimePicker(textField: self.endTimeTextField)
        
        self.showPicker(textField: self.routineTextField)
        
        let sourceLatLongArray = self.routesArray[0].components(separatedBy: CharacterSet(charactersIn: ","))
        let sourcePosition = CLLocationCoordinate2D.init(latitude: Double(sourceLatLongArray[0])!, longitude: Double(sourceLatLongArray[1])!)
        
        let destinationLatLongArray = self.routesArray[self.routesArray.count - 1].components(separatedBy: CharacterSet(charactersIn: ","))
        let destinationPosition = CLLocationCoordinate2D.init(latitude: Double(destinationLatLongArray[0])!, longitude: Double(destinationLatLongArray[1])!)
        
        let sourceCoordinate = CLLocation.init(latitude: sourcePosition.latitude, longitude: sourcePosition.longitude)
        let destinationCoordinate = CLLocation.init(latitude: destinationPosition.latitude, longitude: destinationPosition.longitude)
        
        let distanceInMeters = sourceCoordinate.distance(from: destinationCoordinate)
        
        let distanceInKM = (distanceInMeters / 1000).rounded(toPlaces: 3)
        
        self.distance.text = String(format: "%@ km", String(distanceInKM))

    }
    
    // Save Button Action.
    @IBAction func saveButtonTapped(_ sender: Any)
    {
        
        if (self.routineTextField.text?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put routine.")
            return
        }
        else if (self.startTimeTextField.text?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put start time.")
            return
        }
        else if (self.endTimeTextField.text?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put end time.")
            return
        }
        else if (self.priceTextField.text?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put price.")
            return
        }
        
        
        var routeString = ""
        
        for i in 0 ... self.routesArray.count - 1
        {
            if i != self.routesArray.count - 1
            {
                routeString = routeString + String(format: "%@|", self.routesArray[i])
            }
            else
            {
                routeString = routeString + self.routesArray[i]
            }
        }
        
        
        
        let db = BasicFunctions.openDatabase()
        BasicFunctions.createTable(db: db)
        
        let id = kRouteList.count + 1
        
        BasicFunctions.insert(id: Int32(id), name: self.routeName! as NSString, vehicle: self.vehicle! as NSString, distance: self.distance!.text! as NSString, routine: self.routineTextField!.text! as NSString, startTime: self.startTimeTextField!.text! as NSString, endTime: self.endTimeTextField!.text! as NSString, price: self.priceTextField!.text! as NSString, coordinates: routeString as NSString, db: db)
        
        kIsRouteSaved = true
        
        BasicFunctions.query()
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // Cancel Button Action.
    @IBAction func cancelButtonTapped(_ sender: UIButton)
    {
        kIsRouteSaved = true
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
//    func dismissVC()   {
//
//        let onConfirm = self.onConfirm
//        // deliberately set to nil just in case there is a self reference
//        self.onConfirm = nil
//        guard let block = onConfirm else { return }
//        block(self)
//    }
    
    // called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
    // Display "Done" and "Cancel" buttons on Time picker.
    
    func showTimePicker(textField:UITextField!){
        
        //Formate Date
        self.timePicker.datePickerMode = .time
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.doneTimePicker(sender:)))
        doneButton.tag = textField.tag
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        
        // add toolbar to textField
        textField.inputAccessoryView = toolbar
        // add datepicker to textField
        textField.inputView = self.timePicker
        
    }
    
    // Done Button Action on Time picker.
    @objc func doneTimePicker(sender : UIBarButtonItem){
        //For date formate
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        
        if sender.tag == 1
        {
            self.startTimeTextField.text = formatter.string(from: self.timePicker.date)
        }
        else if sender.tag == 2
        {
            self.endTimeTextField.text = formatter.string(from: self.timePicker.date)
            
        }
        
        
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    // Cancel Button Action on Time picker.
    @objc func cancelClick() {
        
        self.view.endEditing(true)
    }
    
    // Display picker view.
    func showPicker(textField:UITextField!)
    {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.blue
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.dropDownPickerView = UIPickerView()
        self.dropDownPickerView.dataSource = self
        self.dropDownPickerView.delegate = self
        
        
        
        textField.inputView = self.dropDownPickerView
        textField.inputAccessoryView = toolBar
        
    }
    
    // When Press Done Button on PickerView
    @objc func doneClick(sender : UIBarButtonItem) {
        
        self.view.endEditing(true)
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.routineList.count + 1
    }
    
    // these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
    // for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
    // If you return back a different object, the old one will be released. the view will be centered in the row rect
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if row == 0
        {
            return "Select Routine"
        }
        
        return self.routineList[row - 1]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var routine : String!
        
        if row == 0
        {
            routine = ""
        }
        else
        {
            routine = self.routineList[row - 1]
        }
        
        self.routineTextField.text = routine
        
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
