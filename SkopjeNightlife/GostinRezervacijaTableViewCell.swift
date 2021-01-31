//
//  GostinRezervacijaTableViewCell.swift
//  SkopjeNightlife
//
//  Created by Filip Dimitrovski on 1/31/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit

class GostinRezervacijaTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    @IBOutlet weak var imelokalLabel: UILabel!
    @IBOutlet weak var datumLabel: UILabel!
    
    @IBOutlet weak var brgostiLabel: UILabel!
    @IBOutlet weak var tiplokalLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var kontaktLabel: UILabel!
    
    
}
