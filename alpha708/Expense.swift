//
//  Expense.swift
//  alpha708
//
//  Created by Ezra Bathini on 21/04/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation

struct Expense {
    //
    
    var description: String
    var billAmount: Float
    var date: String
    var owingEzra: Float
    var owingRam: Float
    var spentRam: Float
    var spentEzra: Float
    
    init(desc: String, billAmount: Float) {
        self.description = desc
        self.billAmount = billAmount
        self.date = " "
        self.owingRam = 0.0
        self.owingEzra = 0.0
        self.spentRam = 0.0
        self.spentEzra = 0.0
    }
    
}
