/**
 * Class RouteDetailVC.swift
 * @package     Application
 * @author      Arslan Ali
 * @email       marslan.ali@gmail.com
 */


import UIKit
import GoogleMaps

class RouteDetailVC: UIViewController {
    
    var routeData : RouteData!
    
    let polyline = GMSPolyline()
    
    @IBOutlet var mapView: GMSMapView!
    
    
//    var pointsOnRoads = [String]()

    // Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let pointsOnRoads = self.routeData.coordinates.components(separatedBy: CharacterSet(charactersIn: "|"))
        
        let path = GMSMutablePath()
        for i in 0 ... pointsOnRoads.count - 1
        {
            let latlongArray = pointsOnRoads[i].components(separatedBy: CharacterSet(charactersIn: ","))
            
            path.addLatitude(Double(latlongArray[0]) ?? 0.0, longitude: Double(latlongArray[1]) ?? 0.0)
            
//            if i == 0
//            {
//                let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D.init(latitude: Double(latlongArray[0])!, longitude: Double(latlongArray[1])!), zoom: 12.5)
//                self.mapView.animate(to: camera)
//            }
        }
        
        
        self.polyline.path = path
        self.polyline.strokeColor = UIColor.blue
        self.polyline.strokeWidth = 3.0
        self.polyline.map = self.mapView
        
        let sourceLatLongArray = pointsOnRoads[0].components(separatedBy: CharacterSet(charactersIn: ","))
        let sourcePosition = CLLocationCoordinate2D.init(latitude: Double(sourceLatLongArray[0])!, longitude: Double(sourceLatLongArray[1])!)
        
        
        let destinationLatLongArray = pointsOnRoads[pointsOnRoads.count - 1].components(separatedBy: CharacterSet(charactersIn: ","))
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
    
    // Back Button Action.
    @IBAction func backButtonTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
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
