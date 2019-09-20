/**
 * Class NameVC.swift
 * @package     Application
 * @author      Arslan Ali
 * @email       marslan.ali@gmail.com
 */


import UIKit

class NameVC: UIViewController,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate
{
    
    @IBOutlet var nameTextField: UITextField!
    
    @IBOutlet var vehicleTextField: UITextField!
    
    
    var dropDownPickerView : UIPickerView!
    
    var vehicleList = ["Bike","Car","Bus"]
    
    var routesArray : [String]!
    

    // Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.showPicker(textField: self.vehicleTextField)
    }
    
    // Next Button Action.
    @IBAction func nextButtonTapped(_ sender: Any)
    {
        if (self.nameTextField.text?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put name of the route.")
            return
        }
        else if (self.vehicleTextField.text?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please select vehicle.")
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SaveRouteVC") as! SaveRouteVC
        vc.routeName = self.nameTextField.text
        vc.vehicle = self.vehicleTextField.text
        vc.routesArray = self.routesArray
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Back Button Action.
    @IBAction func backButtonTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    // // called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    // Display "Done" and "Cancel" button on keyboard.
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
    
    // When Press Cancel Button on PickerView
    @objc func cancelClick() {
        
        self.view.endEditing(true)
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return self.vehicleList.count + 1
    }
    
    // These methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
    // for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
    // If you return back a different object, the old one will be released. the view will be centered in the row rect
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if row == 0
        {
            return "Select Vehicle"
        }
        
        return self.vehicleList[row - 1]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        var vehicle : String!
        
        if row == 0
        {
            vehicle = ""
        }
        else
        {
            vehicle = self.vehicleList[row - 1]
        }
        
        self.vehicleTextField.text = vehicle
        
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
