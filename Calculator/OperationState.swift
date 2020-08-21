//
//  OperationState.swift
//  Calculator
//
//  Created by Dhanshree Nagre on 21/08/20.
//

import UIKit

//enum Operators: Int, Codable, CaseIterable, CodingKey {
//    case division
//    case multiplication
//    case minus
//    case plus
//
////    var operatorValue: String {
////        switch self {
////        case .plus: return "+"
////        case .minus: return "-"
////        case .multiplication: return "*"
////        case .division: return "/"
////        }
////    }
//}

/// State for describing a state of the operands
///
struct OperationState: Equatable {

    // MARK: Properties

    /// The boolean value to represent is this a value or operator
    let isOperator: Bool

    /// The actual operator to perform the MADS.
    let operatorEntered: String?

    /// The operands on which operation is to be performed.
    let number: Double?

    /// The priority of the operator if Entered
    let priority: Int?

}
