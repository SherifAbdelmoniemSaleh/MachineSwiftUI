//
//  QuestionViewModel.swift
//  MachineSwiftUI
//
//  Created by Sherif Abd El-Moniem on 11/09/2021.
//

import Foundation
class QuestionViewModel: ObservableObject {
    @Published var questionsList = [QuestionModel]()
}
