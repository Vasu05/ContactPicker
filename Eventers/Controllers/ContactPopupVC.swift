//
//  ContactPopupVC.swift
//  Eventers
//
//  Created by Vasu Chand on 19/04/19.
//  Copyright © 2019 Vasu Chand. All rights reserved.
//

import UIKit
import SwiftMessages

protocol ContactPopupVCdelegate :class{
    func cellselected(number:String)
}

class ContactPopupVC: UIViewController {

    @IBOutlet weak var mTableView: UITableView!
    let cell_Identifier = "ContactPopupTblCell"
    var mContentHeight:CGFloat = 0
    var mScreen:CGRect!
    weak var delegate: ContactPopupVCdelegate?
    @IBOutlet weak var mNameLbl: UILabel!
    //MARK:- Properties
    var pNumbers:[String]?
    var pName  = ""
    let cellHeight = 40

    override func viewDidLoad() {
        super.viewDidLoad()
        mTableView.delegate = self
        mTableView.dataSource = self
        registerNib()
        self.configureUI()
        mTableView.reloadData()

    }
    override func awakeFromNib() {
        super.awakeFromNib()
        mScreen = UIScreen.main.bounds
        self.contentSizeInPopup = CGSize(width: 0.1, height: 1)
        
    }
    
    func registerNib(){
        let CellNib = UINib.init(nibName: cell_Identifier, bundle: nil)
        mTableView.register(CellNib, forCellReuseIdentifier: cell_Identifier)
        
    }
    
    func configureUI(){
        mNameLbl.text = pName
        let count = pNumbers?.count ?? 0 ;
   
        let height  =  count * cellHeight + 40;
        mContentHeight = CGFloat(height)
        self.loadViewIfNeeded()
        
        
        if (mContentHeight )  >  mScreen.size.height //[UIScreen mainScreen].bounds.size.height)
        {
            self.contentSizeInPopup =    CGSize(width: mScreen.size.width/1.1
                , height: mScreen.size.height)
        }
        else
        {
            self.contentSizeInPopup = CGSize(width: mScreen.size.width/1.1
                , height: mContentHeight)
        }
    }
    
}

extension ContactPopupVC : UITableViewDelegate ,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pNumbers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell  = mTableView.dequeueReusableCell(withIdentifier: cell_Identifier) as? ContactPopupTblCell{
            let cellData = pNumbers?[indexPath.row] ?? ""
            cell.configureUI(phoneNumber: cellData,index: indexPath.row)
            return cell
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
}

extension ContactPopupVC : ContactPopupTblCelldelegate{
    func cellTapped(index: Int) {
        
    }
}
