//
//  BankApi.swift
//  Rely
//
//  Created by Ryan Auger on 7/16/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import Foundation

class BankApi {
    // link bank account
    func linkPlaid(id: Int, publicToken: String, completion: @escaping WebServiceResponse) {
        let queryString = "?public_token=" + publicToken
        apiGET(endpoint: .User, path: "/plaid-link" + queryString, completion: completion)
    }
    func linkBank(id: Int, bank: BankModel, completion: @escaping WebServiceResponse) {
        apiPOST(endpoint: .User, path: "/bank-link", body:
            [
                "user_id": id,
                "bank_id": bank.id,
                "name": bank.name,
                "mask": bank.mask,
                "type": bank.type,
                "subtype": bank.subtype
            ], completion: completion)
    }
    func getAll(id: Int, completion: @escaping WebServiceResponse) {
        let queryString = "?user_id=" + String(id)
        apiGET(endpoint: .User, path: "/bank-accounts" + queryString, completion: completion)
    }
}
