//
//  ItemTableCell.swift
//  j'DIRN
//
//  Created by Рахат Султаналиулы on 16.01.2023.
//

import UIKit

class ItemTableCell: UITableViewCell {

    @IBOutlet weak var itemNumber: UILabel!
    @IBOutlet weak var label: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
