//
//  StripeClient.swift
//  MoviesNow
//
//  Created by Gunasai Garapati on 4/29/19.
//  Copyright © 2019 Gunasai Garapati. All rights reserved.
//

import Foundation
import Alamofire
import Stripe

import Foundation
import Alamofire
import Stripe

enum TransactionResult {
    case success
    case failure(Error)
}

final class StripeClient {
    
    static let shared = StripeClient()
    
    
    
    private init() {
        // private
    }
    
    
    private lazy var baseURL: URL = {
        guard let url = URL(string: Constants.baseURLString) else {
            fatalError("Invalid URL")
        }
        return url
    }()
    
    func completeCharge(with token: STPToken, amount: Int, completion: @escaping (TransactionResult) -> Void) {
        // 1
        let url = baseURL.appendingPathComponent("charge")
        // 2
        let params: [String: Any] = [
            "token": token.tokenId,
            "amount": amount,
            "currency": Constants.defaultCurrency,
            "description": Constants.defaultDescription
        ]
        // 3
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success:
                    completion(TransactionResult.success)
                case .failure(let error):
                    if let data = response.data {
                        let json = String(data: data, encoding: String.Encoding.utf8)
                        print("Failure Response: \(String(describing: json))")
                    }
                    completion(TransactionResult.failure(error))
                }
        }
    }
    
    
    
    
}
