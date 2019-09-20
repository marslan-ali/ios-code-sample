//
//  RouteCell.swift
//  FindRoute
//
//  Created by ShayanSolutions on 3/8/19.
//  Copyright © 2019 ShayanSolutions. All rights reserved.
//

import UIKit

class RouteCell: UITableViewCell
{
    
    @IBOutlet var name: UILabel!
    @IBOutlet var vehicleImageView: UIImageView!
    @IBOutlet var time: UILabel!
    @IBOutlet var routine: UILabel!
    @IBOutlet var distance: UILabel!
    @IBOutlet var cost: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
