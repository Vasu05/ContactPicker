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
    
    var pDataSource:[contactModel]?
    let cell_Identifier = "ContactPageTblCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mTableView.delegate = self
        mTableView.dataSource = self
        registerNib()
        mTableView.reloadData()

        // Do any additional setup after loading the view.
    }
    func registerNib(){
        let CellNib = UINib.init(nibName: cell_Identifier, bundle: nil)
        mTableView.register(CellNib, forCellReuseIdentifier: cell_Identifier)
    }
}
extension ContactDetailPageVC: UITableViewDelegate ,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell  = mTableView.dequeueReusableCell(withIdentifier: "ContactPageTblCell") as? ContactPageTblCell{
            cell.delegate = self
            if var dataObj = pDataSource{
               cell.configureUI(obj: dataObj[indexPath.row],index: indexPath.row)
            }
            return cell
        }
        
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  pDataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = pDataSource?[indexPath.row].phoneNumbers ?? [String]()
        
        if data.count > 1{
            
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  100//UITableView.automaticDimension
    }
}

extension ContactDetailPageVC : ContactPageTblCelldelegate{
    func cellTapped(index: Int) {
        
        let data = pDataSource?[index]
        if let numbers = data?.phoneNumbers{
            if numbers.count > 1{
                
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactPopupVC") as? ContactPopupVC{
                    //self.navigationController?.pushViewController(vc, animated: true)
                    vc.pNumbers = numbers
                    vc.pName = data?.givenName ?? ""
                    let popup = STPopupController.init(rootViewController: vc)
                    popup.style = .formSheet
                   
                    popup.transitionStyle = .slideVertical
                    popup.navigationBarHidden = true
                    popup.present(in: self)
                }
    
            }
        }
        else{
            mTableView.reloadData()
        }
    }
}
