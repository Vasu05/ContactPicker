//
//  ContactDetailPageVC.swift
//  Eventers
//
//  Created by Vasu Chand on 19/04/19.
//  Copyright © 2019 Vasu Chand. All rights reserved.
//

import UIKit


class ContactDetailPageVC: UIViewController {

    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var mFinishBtn: UIButton!
    
    var pDataSource:[contactModel]?
    let cell_Identifier = "ContactPageTblCell"
    var mLastSelectedCell = -1
    var mTblDataSource = [MKGenericTblDataModel]()
    
    //MARK:- Properties
    var pEnterText = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mTableView.delegate = self
        mTableView.dataSource = self
        registerNib()
        configureDataSource()
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
    
    func configureDataSource(){
        
        if let dataSource = pDataSource{
            for item in dataSource{
                let data = MKGenericTblDataModel()
                data.pCustom1 = item // contact info
                data.pCustom2 = false // ischecked
                data.pCustom3 = "" // selectedNumber
                mTblDataSource.append(data)
            }
        }
    
    }
    
    @IBAction func finishBtnPressed(_ sender: Any) {
        var selected = 0
        var selectedDataSource = [MKGenericTblDataModel]()
        for item in mTblDataSource{
            let isSelecetd = item.pCustom2 as? Bool ??  false
            if isSelecetd{
                selected = selected + 1
                selectedDataSource.append(item)
            }
        }
        
        guard selected > 0 else{
            showToast("Please Select Contact First")
            return
        }
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "FinalPageVC") as? FinalPageVC{
            vc.pDataSource = selectedDataSource
            vc.pAddedtext = pEnterText
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
extension ContactDetailPageVC: UITableViewDelegate ,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell  = mTableView.dequeueReusableCell(withIdentifier: "ContactPageTblCell") as? ContactPageTblCell{
            cell.delegate = self
            
            let dataObj = mTblDataSource[indexPath.row]
            
            if let contactData = dataObj.pCustom1 as? contactModel{
               cell.configureUI(obj: contactData, index: indexPath.row,cellData: dataObj)
            }
            return cell
        }
        
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  mTblDataSource.count
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        mLastSelectedCell = indexPath.row
//        let data = mTblDataSource[indexPath.row]
//        let cellSelected = data.pCustom2 as? Bool ?? false
//        data.pCustom2 = !cellSelected
//        //mTableView.reloadData()
//        if let cellObj = data.pCustom1 as? contactModel,cellSelected{
//            if cellObj.phoneNumbers?.count ?? 0 > 1{
//                
//                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactPopupVC") as? ContactPopupVC{
//                    //self.navigationController?.pushViewController(vc, animated: true)
//                    vc.pNumbers = cellObj.phoneNumbers
//                    vc.pName = cellObj.givenName ?? ""
//                    vc.delegate = self
//                    let popup = STPopupController.init(rootViewController: vc)
//                    popup.style = .formSheet
//                    popup.transitionStyle = .slideVertical
//                    popup.navigationBarHidden = true
//                    popup.present(in: self)
//                }
//            }
//            else{
//                data.pCustom3 = cellObj.phoneNumbers?.first ?? ""
//                mTableView.reloadData()
//            }
//            
//        }
//        else{
//            data.pCustom3 = ""
//            mTableView.reloadData()
//        }
//        
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  100//UITableView.automaticDimension
    }
}
// MARK:- table cell delegate
extension ContactDetailPageVC : ContactPageTblCelldelegate{
    func cellTapped(index: Int) {
        
        let data = mTblDataSource[index]
        mLastSelectedCell = index
        let cellSelected = data.pCustom2 as? Bool ?? false
        
        if let cellObj = data.pCustom1 as? contactModel{
            if cellObj.phoneNumbers?.count ?? 0 > 1,cellSelected{
                
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactPopupVC") as? ContactPopupVC{
                    //self.navigationController?.pushViewController(vc, animated: true)
                    vc.pNumbers = cellObj.phoneNumbers
                    vc.pName = cellObj.givenName ?? ""
                    vc.delegate = self
                    let popup = STPopupController.init(rootViewController: vc)
                    popup.style = .formSheet
                    popup.transitionStyle = .slideVertical
                    popup.navigationBarHidden = true
                    popup.present(in: self)
                }
            }
            else{
                data.pCustom3 = cellObj.phoneNumbers?.first ?? ""
                mTableView.reloadData()
            }
            
        }
        
    }
}
//MARK:- POPUP delegate
extension ContactDetailPageVC : ContactPopupVCdelegate{
    
    func cellselected(number: String) {
        let data = mTblDataSource[mLastSelectedCell]
        data.pCustom3 = number
        mTableView.reloadData()
    }
}
