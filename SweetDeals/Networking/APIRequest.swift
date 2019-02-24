//
//  APIRequest.swift
//  SweetDeals
//
//  Created by Anteneh Sahledengel on 5/13/18.
//  Copyright © 2018 Anteneh Sahledengel. All rights reserved.
//

import UIKit
import Alamofire

class APIRequest {
    
    var apiUrlString: URLConvertible?
    var parameters: [String: Any]?
    var requestMethod = HTTPMethod.get
    var parameterEncoding = URLEncoding.default
    var headers: HTTPHeaders? = nil
    
    private var alamofireRequest: DataRequest? {
        guard let urlString = apiUrlString  else { assert(false, ""); return nil }
        
        return Alamofire.request(urlString,
                                 method: requestMethod,
                                 parameters: parameters,
                                 encoding: parameterEncoding,
                                 headers: headers).validate()
    }
    
    func responseCodable<T: Codable>(withCompletion completion: @escaping (T?, Error?) -> ()) {
        responseData { (data, error) in
            guard error == nil, data != nil else {
                print("Error while fetching from API: \(String(describing: error))")
                completion(nil, error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                //This could also come as an APIRequest parameter.
                decoder.dateDecodingStrategy = .iso8601
                let codableObject = try decoder.decode(T.self, from: data!)
                completion(codableObject, nil)
            } catch let exception {
                completion(nil, exception)
                assert(false, "Unexpected JSON Format")
            }
        }
    }
    
    func responseData(withCompletion completion: @escaping (Data?, Error?) -> ()) {
        
        alamofireRequest?.responseData { (response) in
            guard response.result.isSuccess else {
                print("Error while fetching from API: \(String(describing: response.result.error))")
                completion(nil, response.result.error)
                return
            }
            
            completion(response.result.value, response.result.error)
        }
    }
}
