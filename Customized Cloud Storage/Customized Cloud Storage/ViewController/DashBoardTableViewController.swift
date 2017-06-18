//
//  DashBoardTableViewController.swift
//  Customized Cloud Storage
//
//  Created by MingE on 2017/6/13.
//  Copyright © 2017年 MingE. All rights reserved.
//

import UIKit
import SideMenu
import Photos

class DashBoardTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let imagePicker = UIImagePickerController()
    
    var user: User? = nil
    var currentClientServer = 0
    //var fileInfo = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //get login status from system
        let loginStatus = UserDefaults.standard.bool(forKey: "loginStatus")
        guard loginStatus else {
            //push login page
            self.performSegue(withIdentifier: "loginViewSegue", sender: self)
            return
        }
        
        updateClientServerData()
        
        //set side menu
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "sideMenuRootView") as! UISideMenuNavigationController
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        
        //set side menu gesture
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view, forMenu: .left)
    }
    
    internal func updateClientServerData(){
        //get user data from system store
        let userData = UserDefaults.standard.data(forKey: "userData")
        let user = NSKeyedUnarchiver.unarchiveObject(with: userData!) as? User
        print("UI dashboard -> System Store -> user email:  \(String(describing: user?.email))")
        print("UI dashboard -> System Store -> user id:  \(String(describing: user?.id))")
        
        //get user client server list
        user?.getClientServerList(){getClientServerListStatus in
            print("UI dashBoard -> user getClientServerList Status: \(getClientServerListStatus)")
            guard getClientServerListStatus else{return}
            
            //set page titile
            DispatchQueue.main.async {
                self.navigationItem.title = ((user?.clientServerList.count)! > 0) ? user?.clientServerList[self.currentClientServer].name : "尚未擁有或尚未選擇儲存空間"
            }
            
            for clientServer in (user?.clientServerList)!{
                clientServer.getFiles(){getFilesStatus in
                    print("UI dashBoard -> user getClientServerList -> getFiles Status: \(getFilesStatus)")
                    guard getFilesStatus else{return}
                    
                    //save user data in system
                    let encodeUserData = NSKeyedArchiver.archivedData(withRootObject: user!)
                    UserDefaults.standard.setValue(encodeUserData, forKey: "userData")
                    UserDefaults.standard.synchronize()
                    
                    self.user = user
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction internal func showSideMenu(){
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction internal func showImagePicker(_ sender: UIBarButtonItem){
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        //imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .popover
        imagePicker.popoverPresentationController?.delegate = self
        imagePicker.popoverPresentationController?.barButtonItem = sender
        imagePicker.popoverPresentationController?.permittedArrowDirections = .any
        present(imagePicker, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    internal func imagePickerAlert(chosenImage: UIImage, filename: String){
        let imagePickerAlerttController = UIAlertController(title: "通知", message: "確定要上傳 ?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        imagePickerAlerttController.addAction(cancelAction)
        let uploadFileAction = UIAlertAction(title: "上傳", style: .default, handler: {(action: UIAlertAction!) -> () in
            self.dismiss(animated: true, completion: nil)
            self.uploadFile(chosenImage: chosenImage, filename: filename)
        })
        imagePickerAlerttController.addAction(uploadFileAction)
        
        imagePicker.present(imagePickerAlerttController, animated: true, completion: nil)
    }
    
    internal func uploadFile(chosenImage: UIImage, filename: String){
        let currentUser = user
        currentUser?.clientServerList[currentClientServer].uploadFile(image: chosenImage, filename: filename){uploadFileStauts in
            guard uploadFileStauts else{
                DispatchQueue.main.async {
                    self.view.makeToast("上傳失敗", duration: 3, position: .center, title: " ", image: UIImage(named: "Delete"), style: nil, completion:nil)
                }
                return
            }
            
            //update dash board
            currentUser?.clientServerList[self.currentClientServer].getFiles(){getFilesStatus in
                print("UI dashBoard -> user getClientServerList -> getFiles Status: \(getFilesStatus)")
                guard getFilesStatus else{
                    DispatchQueue.main.async {
                        self.view.makeToast("資料更新失敗，請重試！", duration: 3, position: .center, title: " ", image: UIImage(named: "Delete"), style: nil, completion:nil)
                    }
                    return
                }
                
                //save user data in system
                let encodeUserData = NSKeyedArchiver.archivedData(withRootObject: currentUser!)
                UserDefaults.standard.setValue(encodeUserData, forKey: "userData")
                UserDefaults.standard.synchronize()
                
                self.user = currentUser
                
                DispatchQueue.main.async {
                    self.view.makeToast("上傳成功", duration: 3, position: .center, title: " ", image: UIImage(named: "Checkmark"), style: nil, completion:nil)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        var filename: String = "filename"
        if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {
            let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
            let asset = result.firstObject
            filename = asset?.value(forKey: "filename") as! String
        }
        
        imagePickerAlert(chosenImage: chosenImage, filename: filename)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return user?.clientServerList[currentClientServer].fileList.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fileInfoCell = tableView.dequeueReusableCell(withIdentifier: "fileInfoCell", for: indexPath) as! FileInfoTableViewCell
        
        let fileList = user?.clientServerList[currentClientServer].fileList
        fileInfoCell.fileNameLabel.text = fileList?[indexPath.row].name
        fileInfoCell.pathLabel.text = fileList?[indexPath.row].path
        fileInfoCell.sizeLabel.text = bytesToSize(bytes: (fileList?[indexPath.row].size)!)

        return fileInfoCell
    }
    
    internal func bytesToSize(bytes: Int) -> String{
        let formatter = ByteCountFormatter()
        formatter.countStyle = .binary
        return formatter.string(fromByteCount: Int64(bytes))
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
