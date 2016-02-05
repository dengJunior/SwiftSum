//
//  YYApid.swift
//  SwiftSum
//
//  Created by yangyuan on 16/2/5.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Alamofire
import Argo

enum YYApi {
    case ShowRoomList(page: Int, size: Int)
    case GoodDesignRecommends
    case None
}

func jsonResponseDataFormatter(data: NSData) -> NSData {
    do {
        let dataAsJson = try NSJSONSerialization.JSONObjectWithData(data, options: [])
        let prettyData = try NSJSONSerialization.dataWithJSONObject(dataAsJson, options: .PrettyPrinted)
        return prettyData
    } catch {
        return data //fallback to original data if it cant be serialized
    }
}

let yyProvider = YYProvider<YYApi>(plugins: [NetworkLoggerPlugin(verbose: false,  responseDataFormatter: jsonResponseDataFormatter)])

var disposeBag = DisposeBag()
extension YYApi {
    static func requestGoodDesignRecommends(completion: [Recommend] -> Void) {
        yyProvider.request(YYApi.GoodDesignRecommends)
            .mapSuccessfulHTTPToObjectArray(Recommend)
            .subscribe(onNext: { items in completion(items); }, onError: { (ErrorType) -> Void in
                print(ErrorType)
                })
            .addDisposableTo(disposeBag);
    }
}

extension YYApi: TargetType {
    var base: String { return "http://www.meilele.com"}
    var baseURL: NSURL { return NSURL(string: base)! }
    
    var path: String {
        switch self {
        case .ShowRoomList(_, _):
            return "/mll_api/api/app_ybj2_list"
        case .GoodDesignRecommends:
            return "/mll_api/api/app_ybj2_recommend"
        default:
            return "/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .GET
        }
    }
    
    var parameters: [String: AnyObject]? {
        switch self {
        case .ShowRoomList(let page, let size):
            return ["page":page, "size":size]
        case .GoodDesignRecommends:
            return ["datarow_need":5];
        default:
            return [:];
        }
    }
    
    var sampleData: NSData {
        switch self {
        default:
            return NSData()
            
        }
    }
}

class YYProvider<T where T: TargetType>: RxMoyaProvider<T> {
    var autoToken: YYAppToken?
    
    override init(endpointClosure: EndpointClosure = MoyaProvider.DefaultEndpointMapping,
        requestClosure: RequestClosure = MoyaProvider.DefaultRequestMapping,
        stubClosure: StubClosure = MoyaProvider.NeverStub,
        manager: Manager = RxMoyaProvider<T>.DefaultAlamofireManager(),
        plugins: [PluginType] = []) {
            super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, manager: manager, plugins: plugins)
    }
    
    // We always use xapp auth, logging in is handled by
    static func AuthEndpointResolution(endpoint: Endpoint<T>) -> NSURLRequest {
        let request = endpoint.endpointByAddingHTTPHeaderFields(["x-appToken":YYAppToken().token ?? ""]).urlRequest
        return request
    }
}


















