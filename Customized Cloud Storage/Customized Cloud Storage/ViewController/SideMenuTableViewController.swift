//
//  SideMenuTableViewController.swift
//  Customized Cloud Storage
//
//  Created by MingE on 2017/6/14.
//  Copyright © 2017年 MingE. All rights reserved.
//

import UIKit

class SideMenuTableViewController: UITableViewController {
    var user: User? = nil
    let sectionTitle = ["用戶資訊 (User Info)",
                        "檔案上傳設定 (File Upload Setting)",
                        "儲存區列表 (Client Server List)", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    //TextField keyboard disappear when user tap other side on screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //get user data from system store
        let userData = UserDefaults.standard.data(forKey: "userData")
        user = NSKeyedUnarchiver.unarchiveObject(with: userData!) as? User
    }
    
    @IBAction internal func addClientServerAlert(){
        let addClientServerController = UIAlertController(title: "新增儲存區", message: "請輸入儲存區名稱及IP位址(Host Name)", preferredStyle: .alert)
        
        addClientServerController.addTextField(configurationHandler: { (textFiled: UITextField!) ->() in
            textFiled.placeholder = "儲存區名稱"
        })
        addClientServerController.addTextField(configurationHandler: { (textFiled: UITextField!) ->() in
            textFiled.placeholder = "IP位址(Host Name)"
            textFiled.keyboardType = .decimalPad
        })
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        addClientServerController.addAction(cancelAction)
        let addClientServerAction = UIAlertAction(title: "送出", style: .default, handler: {(action: UIAlertAction!) -> () in
            let clientServerName = (addClientServerController.textFields?.first)! as UITextField
            let clientServerHostName = (addClientServerController.textFields?.last)! as UITextField
            self.addClientServer(name: clientServerName.text!, host: clientServerHostName.text!)
        })
        addClientServerController.addAction(addClientServerAction)
        
        self.present(addClientServerController, animated: true, completion: nil)
    }
    
    internal func addClientServer(name: String, host: String){
        //print("UI side menu -> add client server: clicked!")
        guard !name.isEmpty || !host.isEmpty else{
            DispatchQueue.main.async {
                self.view.makeToast("未輸入資料", duration: 3, position: .center, title: " ", image: UIImage(named: "Delete"), style: nil, completion:nil)
            }
            return
        }
        
        guard validateIpAddress(ipToValidate: host) else {
            DispatchQueue.main.async {
                self.view.makeToast("IP位址格式不正確", duration: 3, position: .center, title: " ", image: UIImage(named: "Delete"), style: nil, completion:nil)
            }
            return
        }
        
        let currentUser = user
        currentUser?.addClientServer(name: name, host: host){addClientServerStatus in
            guard addClientServerStatus else{
                DispatchQueue.main.async {
                    self.view.makeToast("新增失敗或Host Name已經重複", duration: 3, position: .center, title: " ", image: UIImage(named: "Delete"), style: nil, completion:nil)
                }
                return
            }
            
            let encodeUserData = NSKeyedArchiver.archivedData(withRootObject: currentUser!)
            UserDefaults.standard.setValue(encodeUserData, forKey: "userData")
            UserDefaults.standard.synchronize()
            
            self.user = currentUser
            
            DispatchQueue.main.sync {
                //reload table view
                self.tableView.reloadData()
                //dismiss side menu
                self.dismiss(animated: false, completion: nil)
                //let app to the initial state
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let dashBoardView: UINavigationController = storyboard.instantiateViewController(withIdentifier: "initialRootView") as! UINavigationController
                UIApplication.shared.keyWindow?.rootViewController = dashBoardView
                dashBoardView.view.makeToast("新增成功", duration: 3, position: .center, title: " ", image: UIImage(named: "Checkmark"), style: nil, completion:nil)
            }
        }
    }
    
    internal func validateIpAddress(ipToValidate: String) -> Bool {
        var sin = sockaddr_in()
        var sin6 = sockaddr_in6()
        
        if ipToValidate.withCString({ cstring in inet_pton(AF_INET6, cstring, &sin6.sin6_addr) }) == 1 {return true}
        else if ipToValidate.withCString({ cstring in inet_pton(AF_INET, cstring, &sin.sin_addr) }) == 1 {return true}
        
        return false
    }
    
    @IBAction internal func logoutAlert(){
        let logoutAlertController = UIAlertController(title: user?.name, message: "你確定要登出嗎 ?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        logoutAlertController.addAction(cancelAction)
        let logoutAction = UIAlertAction(title: "登出", style: .destructive, handler: {(action: UIAlertAction!) -> () in
            self.logout()
        })
        logoutAlertController.addAction(logoutAction)
        
        self.present(logoutAlertController, animated: true, completion: nil)
    }
    
    internal func logout(){
        //print to debug
        print("UI side menu: logout!!!!")
        
        //set user data in system store
        UserDefaults.standard.removeObject(forKey: "userData")
        UserDefaults.standard.removeObject(forKey: "loginStatus")
        UserDefaults.standard.removeObject(forKey: "isCompression")
        UserDefaults.standard.synchronize()
        
        //dismiss side menu
        dismiss(animated: false, completion: nil)
        
        //let app to the initial state
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let dashBoardView: UINavigationController = storyboard.instantiateViewController(withIdentifier: "initialRootView") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = dashBoardView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //print("UI side menu -> section count: \(sectionTitle.count)")
        return sectionTitle.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // the 3rd section put client server list
        guard section != 2 else{
            //print("UI side menu -> client server list count: \(String(describing: user?.clientServerList.count))")
            return (user?.clientServerList.count)!
        }
        
        // the last section that put an addClientServer button && an empty cell & a logout button
        guard section != 3 else{
            return 3
        }
        
        // other sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "headerCell")
        header?.textLabel?.text = sectionTitle[section]
        header?.isUserInteractionEnabled = false
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //set user name in the 1st section
        guard indexPath.section != 0 else{
            let userDataCell = tableView.dequeueReusableCell(withIdentifier: "subtitleCell", for: indexPath)
            userDataCell.textLabel?.text = user?.name
            userDataCell.detailTextLabel?.text = user?.email
            userDataCell.isUserInteractionEnabled = false
            //userDataCell.he
            return userDataCell
        }
        
        //set file compression switch in the 2nd section
        guard indexPath.section != 1 else{
            let compressionSwitchCell = tableView.dequeueReusableCell(withIdentifier: "compressionSwitchCell", for: indexPath)
            return compressionSwitchCell
        }
        
        //set an empty cell at the 2nd-last index
        guard indexPath.section != 3 else{
            //set add client server button at the first cell
            guard indexPath.row != indexPath.startIndex else{
                let addClientServerButtonCell = tableView.dequeueReusableCell(withIdentifier: "addClientServerButtonCell", for: indexPath)
                return addClientServerButtonCell
            }
            
            guard indexPath.row != indexPath.startIndex + 1 else{
                let emptyCell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
                emptyCell.isUserInteractionEnabled = false
                return emptyCell
            }
            
            //set logout button in the last index cell
            let logoutButtonCell = tableView.dequeueReusableCell(withIdentifier: "logoutButtonCell", for: indexPath)
            return logoutButtonCell
        }
        
        //print("UI side menu -> section \(indexPath.section) -> indexPath.row: \(indexPath.row)")
        //print("indexPath.endIndex: \(indexPath.endIndex)")
        //set client server list in other's cell
        let clientServerListCell = tableView.dequeueReusableCell(withIdentifier: "subtitleCell", for: indexPath)
        let clientServer = user?.clientServerList[indexPath.row]
        clientServerListCell.textLabel?.text = clientServer?.name
        clientServerListCell.detailTextLabel?.text = clientServer?.host
        return clientServerListCell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
