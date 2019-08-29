//
//  Search.swift
//  Rely
//
//  Created by Ryan Auger on 7/1/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import Foundation
import SocketIO

class Search {
    
    let manager = SocketManager(socketURL: URL(string: Config().rootUrl)!)
    var socket : SocketIOClient!

    init() {
       self.socket = self.manager.defaultSocket
    }
    
    func connect() {
        self.socket = self.manager.defaultSocket
        self.socket.connect()
    }
    
    // MARK: Emissions
    func start_deal_search(userID: Int, term: String) {
        let json = "{ \"user_id\": \"\(userID)\", \"term\": \"\(term)\" }"
        self.socket.emit("deal_search", json)
    }
    func start_user_search(userID: Int, term: String) {
        let json = "{ \"user_id\": \"\(userID)\", \"term\": \"\(term)\" }"
        self.socket.emit("users_search", json)
    }

    // MARK: Callbacks
    func setConnectCallback(callback: @escaping NormalCallback) {
        self.socket?.on("connect", callback: callback)
    }
    func setUserSearchCallback(callback: @escaping NormalCallback) {
        self.socket?.on("users_result", callback: callback)
    }
    func setDealSearchCallback(callback: @escaping NormalCallback) {
        self.socket?.on("deal_result", callback: callback)
    }
    

}
