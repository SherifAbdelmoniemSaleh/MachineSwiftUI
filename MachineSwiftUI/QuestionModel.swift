//
//  QuestionModel.swift
//  MachineSwiftUI
//
//  Created by Sherif Abd El-Moniem on 11/09/2021.
//


import Foundation
import SwiftUI

class QuestionModel : Identifiable , ObservableObject {
    
    @Published var firstNumber: Int?
    @Published var secondNumber: Int?
    @Published var delayTime : Int? = 1
    @Published var isShowLocation = false
    @Published var operation: OprationsEnum = .Sum
    
    var answer: String? = ""
    var latitude: Double? = 0.0
    var longitude: Double? = 0.0
    
    var isQuestionMissing: Bool {
        if firstNumber != nil
            && secondNumber != nil
        {
            return true
        }
        return false
    }

    
    var firstNumberPrompt: String {
        if firstNumber != nil {
            return ""
        } else {
            return "First Number Is Missing"
        }
    }
    
    var secondNumberPrompt: String {
        if secondNumber != nil {
            return ""
        } else {
            return "Second Number Is Missing"
        }
    }


}
enum OprationsEnum:String, CaseIterable, Identifiable  {
//    var id : ObjectIdentifier
    var id : String { self.rawValue }
    case Sum = "+"
    case Sub = "_"
    case Multiply = "*"
    case Devide = "/"
  
  
}

