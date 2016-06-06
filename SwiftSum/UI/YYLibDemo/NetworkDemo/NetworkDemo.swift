//
//  NetworkDemo.swift
//  SwiftSum
//
//  Created by yangyuan on 16/2/4.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import YYKit

class NetworkDemo: UIViewController {
    
    var http: YYHttp?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//                YYApi.requestGoodDesignRecommends{  recommends in
        //            print(recommends);
        //        }
        let url = "http://www.meilele.com/mll_api/api/app_ybj2_recommend"
        self.addButtonToViewWithTitle("Get 请求") {  (button) in
            self.http = YYHttp.build(urlString: url)
                .addParams(["datarow_need": "5"])
                .responseJSON{ (dictOrArray, response, error) in
                    print(dictOrArray)
            }
        }
    }
    
    
    
}
