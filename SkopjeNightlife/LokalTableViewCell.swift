//
//  LokalTableViewCell.swift
//  SkopjeNightlife
//
//  Created by Filip Dimitrovski on 1/29/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit

class LokalTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var tipLokal: UILabel!
    
    @IBOutlet weak var imeLokal: UILabel!
    
    @IBOutlet weak var imageplace: UIImageView!
    
}
