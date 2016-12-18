//
//  RealmModel.swift
//  RealmSample
//
//  Created by Fan on 2016/12/18.
//  Copyright © 2016年 Luke. All rights reserved.
//

import RealmSwift

class HouseInfoRealm: Object {
    dynamic var id : String?
    dynamic var title: String? //標題
    dynamic var simpleIntro: String? //簡短介紹
    dynamic var landlordName : String? //房東姓名
    dynamic var address : String? //地址
    dynamic var telephone : String? //電話
    dynamic var isRent : Int = 0//是否已出租
    
    //MARK: 格式為字串
    //    dynamic var pictures : [String]?//房屋圖片

}

