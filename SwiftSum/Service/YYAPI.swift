//
//  YYAPI.swift
//  SwiftNetwork
//
//  Created by yangyuan on 16/2/4.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Alamofire
import Argo

enum MllApi {
    case ShowRoom(page: Int, size: Int)
    case Recommends
}

extension MllApi: TargetType {
    var base: String { return "http://www.meilele.com"}
    var baseURL: NSURL { return NSURL(string: base)! }
    
    var path: String {
        switch self {
        case .ShowRoom(_, _):
            return "/mll_api/api/app_ybj2_list"
        case .Recommends:
            return "/mll_api/api/app_ybj2_recommend"
            
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
        case .ShowRoom(let page, let size):
            return ["page":page, "size":size]
        case .Recommends:
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

func jsonResponseDataFormatter(data: NSData) -> NSData {
    do {
        let dataAsJson = try NSJSONSerialization.JSONObjectWithData(data, options: [])
        let prettyData = try NSJSONSerialization.dataWithJSONObject(dataAsJson, options: .PrettyPrinted)
        return prettyData
    } catch {
        return data //fallback to original data if it cant be serialized
    }
}

let MllPrivider = RxMoyaProvider<MllApi>(plugins: [NetworkLoggerPlugin(verbose: false,  responseDataFormatter: jsonResponseDataFormatter)])
//let MllPrivider = MoyaProvider<MllApi>(plugins: [NetworkLoggerPlugin(verbose: false,  responseDataFormatter: jsonResponseDataFormatter)])
var disposeBag = DisposeBag()

extension MllApi {
    static func getRecommend(completion: [Recommend] -> Void) {
        disposeBag = DisposeBag()
        MllPrivider.request(MllApi.Recommends)
            .mapSuccessfulHTTPToObjectArray(Recommend)
            .subscribe( onNext: { items in
                completion(items);
            })
            .addDisposableTo(disposeBag);
    }
}


enum ORMError : ErrorType {
    case ORMNoRepresentor
    case ORMNotSuccessfulHTTP
    case ORMNoData
    case ORMCouldNotMakeObjectError
}

extension Observable {
    private func resultFromJson<T: Decodable>(object:[String: AnyObject], classType: T.Type) -> T? {
        let decoded = classType.decode(JSON.parse(object))
        switch decoded {
        case .Success(let result):
            return result as? T
        case .Failure(let error):
            //            log.error(error);
            print(error)
            return nil
        }
        
    }
    
    func mapSuccessfullHttpToObject<T: Decodable>(type: T.Type) -> Observable<T> {
        return map { representor in
            guard let response = representor as? Moya.Response else {
                throw ORMError.ORMNoRepresentor
            }
            
            // Allow successful HTTP codes
            guard ((200...209) ~= response.statusCode) else {
                if let json = try? NSJSONSerialization.JSONObjectWithData(response.data, options: .AllowFragments) as? [String: AnyObject] {
                    print("Got error message: \(json)")
                }
                throw ORMError.ORMNotSuccessfulHTTP
            }
            
            do {
                guard let json = try NSJSONSerialization.JSONObjectWithData(response.data, options: .AllowFragments) as? [String: AnyObject] else {
                    throw ORMError.ORMCouldNotMakeObjectError
                }
                return self.resultFromJson(json, classType: type)!
            } catch {
                throw ORMError.ORMCouldNotMakeObjectError
            }
        }
    }
    
    func mapSuccessfulHTTPToObjectArray<T: Decodable>(type: T.Type) -> Observable<[T]> {
        return map { representor in
            guard let response = representor as? Moya.Response else {
                throw ORMError.ORMNoRepresentor
            }
            
            // Allow successful HTTP codes
            guard ((200...209) ~= response.statusCode) else {
                if let json = try? NSJSONSerialization.JSONObjectWithData(response.data, options: .AllowFragments) as? [String: AnyObject] {
                    print("Got error message: \(json)")
                }
                throw ORMError.ORMNotSuccessfulHTTP
            }
            
            do {
                guard let json = try NSJSONSerialization.JSONObjectWithData(response.data, options: .AllowFragments) as? [[String : AnyObject]] else {
                    throw ORMError.ORMCouldNotMakeObjectError
                }
                
                // Objects are not guaranteed, thus cannot directly map.
                var objects = [T]()
                for dict in json {
                    if let obj = self.resultFromJson(dict, classType: type) {
                        objects.append(obj)
                    }
                }
                return objects
            } catch {
                throw ORMError.ORMCouldNotMakeObjectError
            }
        }
    }
}



