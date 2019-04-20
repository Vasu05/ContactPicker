//
//  FinalPageVC.swift
//  Eventers
//
//  Created by Vasu Chand on 20/04/19.
//  Copyright © 2019 Vasu Chand. All rights reserved.
//

import UIKit

class FinalPageVC: UIViewController {

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var mTableView: UITableView!
    
     let cell_Identifier = "FinalPageTblCell"
    //MARK:- Properties
    var pDataSource:[MKGenericTblDataModel] = [MKGenericTblDataModel]()
    var pAddedtext : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        headerLbl.text = pAddedtext
        mTableView.delegate = self
        mTableView.dataSource = self
        mTableView.reloadData()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func registerNib(){
        let CellNib = UINib.init(nibName: cell_Identifier, bundle: nil)
        mTableView.register(CellNib, forCellReuseIdentifier: cell_Identifier)
    }

}
extension FinalPageVC: UITableViewDelegate ,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell  = mTableView.dequeueReusableCell(withIdentifier: cell_Identifier) as? FinalPageTblCell{
          
            
            let dataObj = pDataSource[indexPath.row]
            let selectedNumber = dataObj.pCustom3 as? String ?? ""
            
            if let contactData = dataObj.pCustom1 as? contactModel{
                cell.configureUIWithDataSource(dataObj: contactData, mobileNumber: selectedNumber,isLastCell: (indexPath.row == pDataSource.count-1))
            }
            return cell
        }
        
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  pDataSource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
}
