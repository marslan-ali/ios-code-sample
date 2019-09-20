/**
 * Class RoutesVC.swift
 * @package     Application
 * @author      Arslan Ali
 * @email       marslan.ali@gmail.com
 */


import UIKit

class RoutesVC: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    
    
    @IBOutlet var routesTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Called when the view is about to made visible. Default does nothing
    override func viewWillAppear(_ animated: Bool)
    {
        
        super.viewWillAppear(true)
        
        self.routesTableView.reloadData()
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return kRouteList.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        var routeCell   = (tableView.dequeueReusableCell(withIdentifier: "RouteCell")) as? RouteCell
        
        if routeCell == nil
        {
            routeCell = Bundle.main.loadNibNamed("RouteCell", owner: nil, options: nil)?[0] as? RouteCell
        }
        
        let routeData = kRouteList[indexPath.row]
        
        routeCell?.name.text = routeData.name
        routeCell?.time.text = String(format: "%@ to %@", routeData.startTime,routeData.endTime)
        routeCell?.routine.text = routeData.routine
        routeCell?.distance.text = routeData.distance
        routeCell?.cost.text = routeData.price + " Rs"
        routeCell?.vehicleImageView.image = UIImage.init(named: routeData.vehicle)
        
        return routeCell!
    }
    // Called after the user changes the selection.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RouteDetailVC") as! RouteDetailVC
        
        vc.routeData = kRouteList[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Data manipulation - insert and delete support
    
    // After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
    // Not called for edit actions using UITableViewRowAction - the action's handler will be invoked instead
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            BasicFunctions.deleteSpecificRow(rowId: Int32(indexPath.row + 1))
            
            kRouteList.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .top)
            
        }
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
