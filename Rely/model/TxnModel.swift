//
//  DealModel.swift
//  Rely
//
//  Created by kavii on 4/24/19.
//  Copyright © 2019 kavii. All rights reserved.
//

import Foundation

enum DEAL_ROLE: Int {
    case PAYER = 0
    case COLLECTOR = 1
}

enum DEAL_STATE: String {
    case DISPUTE = "DISPUTE"
    case TIMEOUT = "TIMEOUT"
    case CANCELLED = "CANCELLED"
    case PENDING = "PENDING"
    case PROGRESS = "PROGRESS"
    case REVIEW = "REVIEW"
    case COMPLETE = "COMPLETE"
}

enum FUND_STATE: String {
    case NOT_FUNDED = "NOT_FUNDED"
    case ISSUE_PENDING = "ISSUE_PENDING"
    case TO_FBO_TRANSFER_PENDING = "TO_FBO_TRANSFER_PENDING"
    case TO_FBO_TRANSFER_COMPLETE = "TO_FBO_TRANSFER_COMPLETE"
    case FEE_PENDING = "FEE_PENDING"
    case FEE_COMPLETE = "FEE_COMPLETE"
    case FROM_FBO_TRANSFER_PENDING = "FROM_FBO_TRANSFER_PENDING"
    case FROM_FBO_TRANSFER_COMPLETE = "FROM_FBO_TRANSFER_COMPLETE"
}


class TxnModel {
    
    var dealId: Int
    var description: String
    var amount: Int
    var reserve: Int
    var endDate: Date
    var dealState: DEAL_STATE
    var fundState: FUND_STATE
    var payer: User
    var collector: User
    var originator: Int

    init(
        dealId: Int,
        description: String,
        amount: Int,
        reserve: Int,
        endDate: Date,
        dealState: DEAL_STATE,
        fundState: FUND_STATE,
        payer: User,
        collector: User,
        originator: Int
    )
    {
        self.dealId = dealId
        self.description = description
        self.amount = amount
        self.reserve = reserve
        self.endDate = endDate
        self.dealState = dealState
        self.fundState = fundState
        self.payer = payer
        self.collector = collector
        self.originator = originator
    }
    

    convenience init?(data: [String: Any]) {
        guard
            let dealId = data["id"] as? Int,
            let description = data["description"] as? String,
            let amount = data["amount"] as? Int,
            let reserve = data["reserve"] as? Int,
            let dealStateStr = data["deal_state"] as? String,
            let dealState = stringToDealState(dealState: dealStateStr),
            let fundStateStr = data["fund_state"] as? String,
            let fundState = stringToFundState(fundState: fundStateStr),
            let payerId = data["payer_id"] as? Int,
            let collectorId = data["collector_id"] as? Int,
            let originator = data["originator_id"] as? Int
        else {
            return nil
        }
        let payer = User.init(
            userId: payerId,
            firstName: data["payer_first_name"] as? String,
            lastName: data["payer_last_name"] as? String,
            email: data["payer_email"] as? String,
            phone: data["payer_phone"] as? String,
            profileImgUrl: data["payer_profile_img_url"] as? String)
        
        let collector = User.init(
            userId: collectorId,
            firstName: data["collector_first_name"] as? String,
            lastName: data["collector_last_name"] as? String,
            email: data["collector_email"] as? String,
            phone: data["collector_phone"] as? String,
            profileImgUrl: data["collector_profile_img_url"] as? String)

        let endDate = Date() // cluge
        self.init(
            dealId: dealId,
            description: description,
            amount: amount,
            reserve: reserve,
            endDate: endDate,
            dealState: dealState,
            fundState: fundState,
            payer: payer,
            collector: collector,
            originator: originator)
    }
    
    
//    {"deal_id":86,"description":"","amount_cost":1,"reserve_cost":1,"period":"5","dealState":"waiting","payer":1,"collector":17,"collector_firstname":"test","collector_lastname":"test","collector_image":null,"payer_firstname":"Kasun","payer_lastname":"Yomal","payer_image":null,"ending_date":"2019-07-06T19:00:08.000Z"}
    
}
func stringToFundState(fundState: String) -> FUND_STATE? {
    switch (fundState) {
    case FUND_STATE.NOT_FUNDED.rawValue:
        return .NOT_FUNDED
    case FUND_STATE.ISSUE_PENDING.rawValue:
        return .ISSUE_PENDING
    case FUND_STATE.TO_FBO_TRANSFER_PENDING.rawValue:
        return .TO_FBO_TRANSFER_PENDING
    case FUND_STATE.TO_FBO_TRANSFER_COMPLETE.rawValue:
        return .TO_FBO_TRANSFER_COMPLETE
    case FUND_STATE.FEE_PENDING.rawValue:
        return .FEE_PENDING
    case FUND_STATE.FEE_COMPLETE.rawValue:
        return .FEE_COMPLETE
    case FUND_STATE.FROM_FBO_TRANSFER_PENDING.rawValue:
        return .FROM_FBO_TRANSFER_PENDING
    case FUND_STATE.FROM_FBO_TRANSFER_COMPLETE.rawValue:
        return .FROM_FBO_TRANSFER_COMPLETE
    default:
        return nil
    }
}
func stringToDealState(dealState: String) -> DEAL_STATE? {
    switch (dealState) {
    case DEAL_STATE.DISPUTE.rawValue:
        return .DISPUTE
    case DEAL_STATE.TIMEOUT.rawValue:
        return .TIMEOUT
    case DEAL_STATE.CANCELLED.rawValue:
        return .CANCELLED
    case DEAL_STATE.PENDING.rawValue:
        return .PENDING
    case DEAL_STATE.PROGRESS.rawValue:
        return .PROGRESS
    case DEAL_STATE.REVIEW.rawValue:
        return .REVIEW
    case DEAL_STATE.COMPLETE.rawValue:
        return .COMPLETE
    default:
        return nil
    }
}

func dateFromString(strDate: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.000Z"
    
    guard let date = dateFormatter.date(from: strDate) else {return nil}
    return Date()
}
func daysRemaining(dateStart: Date, dateEnd: Date) -> Int? {
    
    let calendar = Calendar.current
    
    let calStart = calendar.startOfDay(for: dateStart)
    let calEnd = calendar.startOfDay(for: dateEnd)
    return calendar.dateComponents([.day], from: calStart, to: calEnd).day
}
