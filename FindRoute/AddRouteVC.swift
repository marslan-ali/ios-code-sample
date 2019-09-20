/**
 * Class AddRouteVC.swift
 * @package     Application
 * @author      Arslan Ali
 * @email       marslan.ali@gmail.com
 */


import UIKit
import GoogleMaps
import SwiftyJSON
import AFNetworking

class AddRouteVC: UIViewController,CLLocationManagerDelegate
{
    
    @IBOutlet var mapView: GMSMapView!
    
    @IBOutlet var startButton: UIButton!
    
    @IBOutlet var endButton: UIButton!
    
    @IBOutlet var saveCancelView: UIView!
    
    @IBOutlet var saveButton: UIButton!
    
    @IBOutlet var cancelButton: UIButton!
    
    
    
    let locationManager = CLLocationManager()
    
    var points = [CLLocationCoordinate2D]()
    
    var isStartTracking : Bool!
    
    let polyline = GMSPolyline()
    
    var pointsOnRoads = [String]()
    

    // Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.useBlurForPopup = true
        
        self.locationManager.delegate = self
        self.locationManager.distanceFilter = 200.0
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.startUpdatingLocation()
        
        self.mapView.isMyLocationEnabled = true
        
//        if self.mapView.myLocation?.coordinate != nil
//        {
//            let camera = GMSCameraPosition.camera(withTarget: (self.mapView.myLocation?.coordinate)!, zoom: 10.0)
//            self.mapView.camera = camera
//        }
    }
    
    // Called when the view is about to made visible. Default does nothing
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        if kIsRouteSaved == true
        {
            self.mapView.clear()
            self.points.removeAll()
            self.pointsOnRoads.removeAll()
            
            if self.saveCancelView.isHidden == false
            {
                self.saveCancelView.isHidden = true
                self.startButton.isHidden = false
            }
            
        }
        
    }
    
    // Start Button Action
    @IBAction func startButtonTapped(_ sender: UIButton)
    {
        self.isStartTracking = true
        
        self.startButton.isHidden = true
        self.endButton.isHidden = false
        
        
        
        self.locationManager.startUpdatingLocation()
    }
    
    // End Button Action
    @IBAction func endButtonTapped(_ sender: Any)
    {
        self.isStartTracking = false
        
        self.endButton.isHidden = true
        
//        self.presentSaveRouteVC()
        
        
//        self.locationManager.stopUpdatingLocation()
        
        if self.points.count > 2
        {
            self.saveCancelView.isHidden = false
            self.drawRoute()
        }
        else
        {
            self.startButton.isHidden = false
        }
        
    }
    
    // Save Button Action
    @IBAction func saveButtonTapped(_ sender: UIButton)
    {
        kIsRouteSaved = false
        
//        self.presentSaveRouteVC()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NameVC") as! NameVC
        vc.routesArray = self.pointsOnRoads
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // Cancel Button Action
    @IBAction func cancelButtonTapped(_ sender: UIButton)
    {
        self.mapView.clear()
        self.points.removeAll()
        self.pointsOnRoads.removeAll()
        
        if self.saveCancelView.isHidden == false
        {
            self.saveCancelView.isHidden = true
            self.startButton.isHidden = false
        }
    }
    
    
    
//    func presentSaveRouteVC ()
//    {
//        let saveRouteVC = self.storyboard?.instantiateViewController(withIdentifier: "SaveRouteVC") as? SaveRouteVC
//        saveRouteVC?.view.frame.size.width = UIScreen.main.bounds.size.width
//        saveRouteVC?.routesArray = self.pointsOnRoads
//
//
//        saveRouteVC?.onConfirm = { vc in
//
//            self.dismissPopupViewController(animated: true, completion: {
//
////                self.polyline.map = nil
//                self.mapView.clear()
//
//                self.locationManager.startUpdatingLocation()
//
//            })
//        }
//        self.presentPopupViewController(saveRouteVC!, animated: true, completion: nil)
//
//    }
    
    
    /*Invoked when new locations are available.  Required for delivery of
    *    deferred locations.  If implemented, updates will
    *    not be delivered to locationManager:didUpdateToLocation:fromLocation:
    *
    *    locations is an array of CLLocation objects in chronological order.
    */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0
        {
            let camera = GMSCameraPosition.camera(withTarget: (locations.last?.coordinate)!, zoom: 19.0)
            self.mapView.animate(to: camera)
        }
        
        if self.isStartTracking == true
        {
            
            self.points.append((locations.last?.coordinate)!)
            
            
//        let pointString = String(format: "%f,%f", (locations.last?.coordinate.latitude)!,(locations.last?.coordinate.longitude)!)
//        self.points.append(pointString)
//        let path = GMSMutablePath()
//        for i in 0 ... self.points.count - 1
//        {
//            let latlongArray = self.points[i].components(separatedBy: CharacterSet(charactersIn: ","))
//
//            path.addLatitude(Double(latlongArray[0]) ?? 0.0, longitude: Double(latlongArray[1]) ?? 0.0)
//        }
//
//        if self.points.count > 2 {
//
//            self.polyline.path = path
//            self.polyline.strokeColor = UIColor.blue
//            self.polyline.strokeWidth = 5.0
//            self.polyline.map = self.mapView
//        }

            return
            
            
            
            
        }
        
        
        
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
    }
    // Draw route using google api.
    func drawRoute()
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        var path = ""

        for i in 0 ... self.points.count - 1
        {
            path = path + String(format: "%f,%f", self.points[i].latitude,self.points[i].longitude)

            if i != self.points.count - 1
            {
                path = path + "|"
            }
        }

        var urlString = String(format: "https://roads.googleapis.com/v1/snapToRoads?path=%@&key=AIzaSyDRknPaFTzqrmHCTyQ6QGcrQMjGFQtK7bg&interpolate=true", path)

        urlString = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!

        let manager=AFHTTPRequestOperationManager()

        manager.responseSerializer = AFJSONResponseSerializer(readingOptions: JSONSerialization.ReadingOptions.allowFragments) as AFJSONResponseSerializer

        manager.requestSerializer = AFJSONRequestSerializer() as AFJSONRequestSerializer

        manager.responseSerializer.acceptableContentTypes = NSSet(objects:"application/json", "text/html", "text/plain", "text/json", "text/javascript", "audio/wav") as Set<NSObject>


        manager.post(urlString, parameters: nil, constructingBodyWith: { (formdata:AFMultipartFormData!) -> Void in
            
            BasicFunctions.stopActivityIndicator(vu: self.view)

        }, success: {  operation, response -> Void in
            //{"responseString" : "Success","result" : {"userId" : "4"},"errorCode" : 1}
            //if(response != nil){
            
            
            let parsedData = JSON(response)
            print("parsedData : \(parsedData)")

//            let status = parsedData["status"].string


            let snappedPoints = parsedData["snappedPoints"].array
            
            if (snappedPoints?.count)! > 0
            {
                
                
                for point in snappedPoints!
                {
                    
                    let pointString = String(format: "%f,%f", (point["location"].dictionary!["latitude"]?.floatValue)!,(point["location"].dictionary!["longitude"]?.floatValue)!)
                    self.pointsOnRoads.append(pointString)
                }
                
                let path = GMSMutablePath()
                for i in 0 ... self.pointsOnRoads.count - 1
                {
                    let latlongArray = self.pointsOnRoads[i].components(separatedBy: CharacterSet(charactersIn: ","))
                    
                    path.addLatitude(Double(latlongArray[0]) ?? 0.0, longitude: Double(latlongArray[1]) ?? 0.0)
                }
                
                    
                    self.polyline.path = path
                    self.polyline.strokeColor = UIColor.blue
                    self.polyline.strokeWidth = 5.0
                    self.polyline.map = self.mapView
                
                let sourceLatLongArray = self.pointsOnRoads[0].components(separatedBy: CharacterSet(charactersIn: ","))
                let sourcePosition = CLLocationCoordinate2D.init(latitude: Double(sourceLatLongArray[0])!, longitude: Double(sourceLatLongArray[1])!)
                
                let destinationLatLongArray = self.pointsOnRoads[self.pointsOnRoads.count - 1].components(separatedBy: CharacterSet(charactersIn: ","))
                let destinationPosition = CLLocationCoordinate2D.init(latitude: Double(destinationLatLongArray[0])!, longitude: Double(destinationLatLongArray[1])!)
                
                let bounds = GMSCoordinateBounds.init(coordinate: sourcePosition, coordinate: destinationPosition)
                let camera: GMSCameraUpdate = GMSCameraUpdate.fit(bounds)
                //  let cameraWithPadding: GMSCameraUpdate = GMSCameraUpdate.fit(bounds, withPadding: 100.0) (will put inset the bounding box from the view's edge)
                
                self.mapView.animate(with: camera)
                
                let sourceMarker = GMSMarker.init(position: sourcePosition)
                sourceMarker.title = "Source position"
                sourceMarker.map = self.mapView
                
                let destinationMarker = GMSMarker.init(position: destinationPosition)
                destinationMarker.title = "Destination position"
                destinationMarker.map = self.mapView
            }



            //  }
        }, failure: {  operation, error -> Void in

//            print(error)
            
            BasicFunctions.showAlert(vc: self, msg: error?.localizedDescription)
            //            let errorDict = NSMutableDictionary()
            //            errorDict.setObject(ErrorCodes.errorCodeFailed.rawValue, forKey: ServiceKeys.keyErrorCode.rawValue as NSCopying)
            //            errorDict.setObject(ErrorMessages.errorTryAgain.rawValue, forKey: ServiceKeys.keyErrorMessage.rawValue as NSCopying)
            //
        })
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
