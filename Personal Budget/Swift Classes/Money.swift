//
//  MiscFunctions.swift
//  Personal Budget
//
//  Created by Zach Bockskopf on 2/8/18.
//  Copyright © 2018 Zach Bockskopf. All rights reserved.
//

import Foundation

enum Currency{
    case USD
    case EUR
    case AUD
    case CAD
    case HKD
    case INR
    case GBP
    case JPY
    case MXN
    case CHF
}

struct ExchangeRate: Hashable{
    let currencyOne: Currency
    let currencyTwo: Currency
    let rate: Float
    
    var inverseRate: Float{
        get{
            return 1/rate
        }
    }
    
    var hashValue: Int{
        get{
            return "\(self)".hashValue
        }
    }
}

func ==(lhs:ExchangeRate, rhs: ExchangeRate)->Bool{
    return lhs.hashValue == rhs.hashValue
}

struct Money: Comparable{
    let money: (NSDecimalNumber, Currency)
    static let decimalHandler = NSDecimalNumberHandler(roundingMode: .bankers, scale: 2, raiseOnExactness: true, raiseOnOverflow: true, raiseOnUnderflow: true, raiseOnDivideByZero: true)
    
    init(amt: Float, currency: Currency){
        money = (NSDecimalNumber(value: amt), currency)
        
    }
    
    init(amt: Decimal, currency: Currency){
        money = (NSDecimalNumber(decimal: amt), currency)
        
    }
    
    init(amt: Double, currency: Currency){
        money = (NSDecimalNumber(value: amt), currency)
        
    }
    init(amt: String, currency: Currency) {
        money = (NSDecimalNumber(string: amt), currency)
    }
    
    var amount: Float {
        get{
            return money.0.rounding(accordingToBehavior: Money.decimalHandler).floatValue
        }
    }
    
    var currency: Currency{
        get{
            return money.1
        }
    }
}


extension Money {
    static var exchange_rates: Set<ExchangeRate> = Set()
    
    func pow(power: Int)->Money{
        let _amt = money.0.raising(toPower: power, withBehavior: Money.decimalHandler)
        return Money(amt: _amt.floatValue, currency: currency)
    }
    
    func amountIn(currency: Currency)->Money{
        let curr_exchange_rate = Money.exchange_rates.filter { (er) -> Bool in
            return (er.currencyOne == self.currency && er.currencyTwo == currency) || (er.currencyTwo == self.currency && er.currencyOne == currency)
        }
        
        guard let er = curr_exchange_rate.first else{
            return Money(amt: money.0.floatValue, currency: currency)
        }
        
        
        if er.currencyOne == self.currency{
            return Money(amt: self.money.0.floatValue * er.rate, currency: currency)
        }
        else{
            return Money(amt: self.money.0.floatValue * er.inverseRate, currency: currency)
        }
    }
    
}


extension Money: CustomStringConvertible{
    var description: String {
        get{
            let _amt = money.0.rounding(accordingToBehavior: Money.decimalHandler)
            return "\(_amt) \(money.1)"
        }
    }
}


extension ExchangeRate: CustomStringConvertible{
    var description: String {
        get{
            return "\(currencyOne)-\(currencyTwo): \(rate)"
        }
    }
}

func ==(lhs:Money, rhs:Money)->Bool{
    if lhs.money.0.compare(rhs.money.0) == .orderedSame &&
        lhs.currency == rhs.currency {
        return true
    }
    
    return false
}

func <(lhs:Money, rhs:Money)->Bool{
    if lhs.currency == rhs.currency && lhs.amount < rhs.amount{
        return true
    }
    
    return false
}


func *(lhs: Money, rhs: Money)->Money{
    if lhs.currency == rhs.currency{
        let money = lhs.money.0.multiplying(by: rhs.money.0)
        
        return Money(amt: money.floatValue, currency: lhs.currency)
    }
    
    return Money(amt: 0.0, currency: lhs.currency)
}

func *(lhs:Money, rhs: Float)->Money{
    let amount = lhs.amount * rhs
    return Money(amt: amount, currency: lhs.currency)
}

func *(lhs:Float, rhs: Money)->Money{
    let amount = lhs * rhs.amount
    return Money(amt: amount, currency: rhs.currency)
}

func /(lhs:Money, rhs:Money)->Money{
    if lhs.currency == rhs.currency{
        let money = lhs.money.0.dividing(by: rhs.money.0)
        
        return Money(amt: money.floatValue, currency: lhs.currency)
    }
    
    return Money(amt: 0.0, currency: lhs.currency)
    
}

func /(lhs:Money, rhs: Float)->Money{
    if rhs != 0.00{
        let amount = lhs.amount / rhs
        return Money(amt: amount, currency: lhs.currency)
    }
    
    return Money(amt: 0.00, currency: lhs.currency)
}

func /(lhs:Float, rhs: Money)->Money{
    if rhs.amount != 0.00{
        let amount = lhs / rhs.amount
        return Money(amt: amount, currency: rhs.currency)
    }
    
    return Money(amt: 0.00, currency: rhs.currency)
}


func +(lhs:Money, rhs:Money)->Money{
    if lhs.currency == rhs.currency{
        let money = lhs.money.0.adding(rhs.money.0)
        
        return Money(amt: money.floatValue, currency: lhs.currency)
    }
    
    return Money(amt: 0.0, currency: lhs.currency)
    
}

func +(lhs:Money, rhs: Float)->Money{
    let amount = lhs.amount + rhs
    return Money(amt: amount, currency: lhs.currency)
}

func +(lhs:Float, rhs: Money)->Money{
    let amount = lhs + rhs.amount
    return Money(amt: amount, currency: rhs.currency)
}


func -(lhs:Money, rhs:Money)->Money{
    if lhs.currency == rhs.currency{
        let money = lhs.money.0.subtracting(rhs.money.0)
        
        return Money(amt: money.floatValue, currency: lhs.currency)
    }
    
    return Money(amt: 0.0, currency: lhs.currency)
    
}

func -(lhs:Money, rhs: Float)->Money{
    let amount = lhs.amount - rhs
    return Money(amt: amount, currency: lhs.currency)
}

func -(lhs:Float, rhs: Money)->Money{
    let amount = lhs - rhs.amount
    return Money(amt: amount, currency: rhs.currency)
}

