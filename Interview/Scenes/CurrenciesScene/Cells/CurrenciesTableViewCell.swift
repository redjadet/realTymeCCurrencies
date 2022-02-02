//
//  CurrenciesTableViewCell.swift
//  Interview
//
//  Created by ilker sevim on 1.02.2022.
//

import UIKit

class CurrenciesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var coinNameLbl: UILabel!
    @IBOutlet weak var coinValueLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
