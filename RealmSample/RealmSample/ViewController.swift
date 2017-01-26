//
//  ViewController.swift
//  RealmSample
//
//  Created by Fan on 2016/12/18.
//  Copyright © 2016年 Luke. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var showDataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: 新增資料
    @IBAction func insertData(_ sender: AnyObject) {
        let realmModel = RealmModel()
        let realm = try! Realm()
        
        realmModel.id = inputText.text
        realmModel.title = titleText.text
        
        try! realm.write {
            realm.add(realmModel)
        }
        showDataLabel.text = "新增\(realmModel.id)與\(realmModel.title)"
        
        
        //MARK: 新增多筆資料採用begin-commit
//        realm.beginWrite()
//        for (index,element) in tempID.enumerated() {
              //MARK: 注意為類別型態資料，共用記憶體
//            let houseInfoRealm = HouseInfoRealm()
//            realmModel.id = inputText.text
//            realmModel.title = titleText.text
//            try! realm.write {
//            //新增資料
//                realm.add(houseInfoRealm)
//            }
//        }
//        
//        do {
//            try realm.commitWrite()
//        } catch let e {
//            print(e)
//        }
        
        
    }
    
    
    //搜尋資料
    @IBAction func showData(_ sender: AnyObject) {
        let realm = try! Realm()
        
        //MARK: 搜尋條件資料
        let predicate = NSPredicate(format: "id = %@ OR title BEGINSWITH %@", inputText.text!, titleText.text!)
//        let datas = realm.objects(RealmModel.self).filter(predicate)
        
        //MARK: 全部資料
        let allDatas = realm.objects(RealmModel.self)
        
        var strs: String = ""
        for (index,element) in allDatas.enumerated() {
            strs += "[\(index)]\(element.title)"
        }
        
        if strs == "" {
            strs = "未輸入條件值或找不到"
        }
        showDataLabel.text = strs
    }
    
    

    //MARK: 刪除資料
    @IBAction func deleteData(_ sender: AnyObject) {
        let realm = try! Realm()
        try! realm.write {
            //刪除全部
            realm.deleteAll()
        }
        
        showDataLabel.text = "已刪除"
    }
    
    
}

