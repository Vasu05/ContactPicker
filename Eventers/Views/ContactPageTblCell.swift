//
//  ContactPageTblCell.swift
//  Eventers
//
//  Created by Vasu Chand on 19/04/19.
//  Copyright © 2019 Vasu Chand. All rights reserved.
//

import UIKit
import SimpleCheckbox

protocol ContactPageTblCelldelegate : class {
    func cellTapped(index:Int)
}

class ContactPageTblCell: UITableViewCell {

    @IBOutlet weak var mContentView: UIView!
    @IBOutlet weak var mImageView: UIImageView!
    @IBOutlet weak var mNameLbl: UILabel!
    @IBOutlet weak var mPhoneNumberLbl: UILabel!
    weak var delegate : ContactPageTblCelldelegate?
    
    var index = -1
    let checkbox = Checkbox(frame: CGRect(x: 240, y: 16, width: 18, height: 18))
    private var cellData:MKGenericTblDataModel?
    
    var showPopup: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mImageView.layer.cornerRadius = 20
        mContentView.layer.cornerRadius = 4
        checkbox.checkmarkStyle = .tick
        checkbox.checkedBorderColor =  UIColor.init(rgb: 0x0073cf)
        checkbox.uncheckedBorderColor = .black
        checkbox.checkmarkColor =  UIColor.init(rgb: 0x0073cf)
        checkbox.useHapticFeedback = true
        checkbox.addTarget(self, action: #selector(checkboxValueChanged(sender:)), for: .valueChanged)
        mContentView.addSubview(checkbox)
        // Initialization code
    }
    
    @objc func checkboxValueChanged(sender: Checkbox) {

        self.layoutIfNeeded()
        cellData?.pCustom2 = true
        print("checkbox value change: \(sender.isChecked)")
        
        if sender.isChecked{
            self.delegate?.cellTapped(index: index)
        }
        else{
            setupUncheckedLbl()
        }
        
    }
    
    func setupCheckedLbl(){
        
        let number = cellData?.pCustom3 as? String ?? ""
        
        if let cellData = cellData?.pCustom1 as? contactModel{
            
            let font1 = UIFont.init(name: "Arial", size: 16.0)
            let font2 = UIFont.init(name: "Arial", size: 14.0)
            let str = cellData.givenName ?? ""
            let str2 = "\n" + number
            let attriString1 = NSAttributedString(string:str, attributes:
                [NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 0x404040),
                 NSAttributedString.Key.font: font1])
            let attriString2 = NSAttributedString(string:str2, attributes:
                [NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 0x808080),
                 NSAttributedString.Key.font: font2])
            let combination = NSMutableAttributedString()
            combination.append(attriString1)
            combination.append(attriString2)
            mNameLbl.attributedText = combination
        }
        
    }
    
    func setupUncheckedLbl(){
        cellData?.pCustom3 = ""
        if let cellData = cellData?.pCustom1 as? contactModel{
            let font1 = UIFont.init(name: "Arial", size: 16.0)
            let attriString1 = NSAttributedString(string:cellData.givenName ?? "" , attributes:
                [NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 0x404040),
                 NSAttributedString.Key.font: font1])
            mNameLbl.attributedText = attriString1
        }
       
    }
    
    func configureUI(obj :contactModel?,index:Int = -1 , cellData : MKGenericTblDataModel){
        self.cellData = cellData
        if let data = obj{
            if let img = data.contactObj?.imageData{
                mImageView.image = UIImage(data: img)
            }
            mNameLbl.text = data.givenName
            
            let selected = cellData.pCustom2 as? Bool ?? false
            
            if selected{
                setupCheckedLbl()
            }
            else{
                setupUncheckedLbl()
            }

        }
        self.index = index
        
    }
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
