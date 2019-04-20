//
//  ContactPopupTblCell.swift
//  Eventers
//
//  Created by Vasu Chand on 19/04/19.
//  Copyright © 2019 Vasu Chand. All rights reserved.
//

import UIKit
import SimpleCheckbox

protocol ContactPopupTblCelldelegate:class {
    func cellTapped(index : Int)
}

class ContactPopupTblCell: UITableViewCell {

    @IBOutlet weak var mPhoneNumberLbl: UILabel!
    @IBOutlet weak var mContentView: UIView!
    let checkbox = Checkbox(frame: CGRect(x: 240, y: 16, width: 18, height: 18))
    weak var delegate : ContactPopupTblCelldelegate?
    var index = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        checkbox.checkmarkStyle = .square
        checkbox.borderStyle = .circle
        checkbox.checkedBorderColor =  UIColor.init(rgb: 0x0073cf)
        checkbox.uncheckedBorderColor = .black
        checkbox.checkmarkColor =  UIColor.init(rgb: 0x0073cf)
        checkbox.useHapticFeedback = true
        checkbox.addTarget(self, action: #selector(checkboxValueChanged(sender:)), for: .valueChanged)
        mContentView.addSubview(checkbox)
        mContentView.layer.cornerRadius = 4
        
    }
    
    @objc func checkboxValueChanged(sender: Checkbox) {
        
       
        self.layoutIfNeeded()
        
        print("checkbox value change: \(sender.isChecked)")
        self.delegate?.cellTapped(index: index)
    }
    
    
    func configureUI(phoneNumber:String,index : Int){
        mPhoneNumberLbl.text = phoneNumber
        self.index = index
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
