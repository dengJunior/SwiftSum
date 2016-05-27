//
//	Recommend.swift
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import Argo
import Curry

struct Recommend{

	var suitPosition : String?
	var suitStyle : String?
	var cityName : String?
	var designeDesc : String?
	var districtName : String?
	var emptyId : String?
	var exprId : String?
	var highImgUrl : String?
	var houseName : String?
	var img290192 : String?
	var img345229 : String?
	var img576382 : String?
	var suitId : String?
	var userLoveNum : String?
}


extension Recommend: Decodable {
    static func decode(json: JSON) -> Decoded<Recommend> {
        let curriedInit = curry(self.init)
        return curriedInit
            <^> json <|? "suitPosition"
            <*> json <|? "suitStyle"
            <*> json <|? "cityName"
            <*> json <|? "designeDesc"
            <*> json <|? "districtName"
            <*> json <|? "emptyId"
            <*> json <|? "exprId"
            <*> json <|? "highImgUrl"
            <*> json <|? "houseName"
            <*> json <|? "img290192"
            <*> json <|? "img345229"
            <*> json <|? "img576382"
            <*> json <|? "suitId"
            <*> json <|? "userLoveNum"
    }
}