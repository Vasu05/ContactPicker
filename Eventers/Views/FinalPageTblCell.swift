//
//  FinalPageTblCell.swift
//  Eventers
//
//  Created by Vasu Chand on 20/04/19.
//  Copyright © 2019 Vasu Chand. All rights reserved.
//

import UIKit

class FinalPageTblCell: UITableViewCell {

    @IBOutlet weak var mUserNameLbl: UILabel!
    @IBOutlet weak var mMobileNumberLbl: UILabel!
    @IBOutlet weak var mLineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureUIWithDataSource(dataObj : contactModel,mobileNumber:String ,isLastCell : Bool = false){
        
        mLineView.isHidden = isLastCell
        mUserNameLbl.text = dataObj.givenName ?? ""
        mMobileNumberLbl.text = mobileNumber
    }
    
}
