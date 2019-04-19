//
//  ContactPageTblCell.swift
//  Eventers
//
//  Created by Vasu Chand on 19/04/19.
//  Copyright © 2019 Vasu Chand. All rights reserved.
//

import UIKit

class ContactPageTblCell: UITableViewCell {

    @IBOutlet weak var mContentView: UIView!
    @IBOutlet weak var mImageView: UIImageView!
    @IBOutlet weak var mNameLbl: UILabel!
    @IBOutlet weak var mPhoneNumberLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
