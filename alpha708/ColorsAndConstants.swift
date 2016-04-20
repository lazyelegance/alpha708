//
//  ColorsAndConstants.swift
//  alpha708
//
//  Created by Ezra Bathini on 18/04/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation
import UIKit



let peterrock = UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1.0)
let peterrock_2 = UIColor(red: 41.0/255.0, green: 128.0/255.0, blue: 185.0/255.0, alpha: 1.0)

let midnightblue = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0)
let midnightblue_2 = UIColor(red: 52.0/255.0, green: 73.0/255.0, blue: 94.0/255.0, alpha: 1.0)

let pomegranate = UIColor(red: 192.0/255.0, green: 57.0/255.0, blue: 43.0/255.0, alpha: 1.0)
let pomegranate_2 = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)


let belizehole = UIColor(red: 41.0/255.0, green: 128.0/255.0, blue: 185.0/255.0, alpha: 1.0)
let nephritis = UIColor(red: 39.0/255.0, green: 174.0/255.0, blue: 96.0/255.0, alpha: 1.0)

let greensea = UIColor(red: 22.0/255.0, green: 160.0/255.0, blue: 133.0/255.0, alpha: 1.0)
//rgba(22, 160, 133,1.0)
let silver = UIColor(red: 189.0/255.0, green: 195.0/255.0, blue: 199.0/255.0, alpha: 1.0)


/*
public enum AddExpenseStep {
    
    case description
    case billAmount
    
    static func toString() -> String {
        switch self {
        case description:
            return "Description"
        case billAmount:
            return "Bill Amount"
        }
    }
}
*/



public enum AddExpenseStep {
    case description
    case billAmount
    case parity
    case finish

    
    func toString() -> String {
        switch self {
        case .description:
            return "Description"
        case .billAmount:
            return "Bill Amount"
        case parity:
            return "Parity"
        case .finish:
            return "Finish"
        }
    }
    
    func nextStep() -> AddExpenseStep {
        switch self {
        case .description:
            return .billAmount
        case .billAmount:
            return .parity
        case .parity:
            return .finish
        case .finish:
            return self
        }
    }
    
    func mongoField() ->String {
        switch self {
        case .description:
            return "Description"
        case .billAmount:
            return "BillAmount"
        case parity:
            return "parity"
        case .finish:
            return "Finish"
        }
    }
    
}