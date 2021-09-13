//
//  ContentView.swift
//  MachineSwiftUI
//
//  Created by Sherif Abd El-Moniem on 11/09/2021.
//

import SwiftUI
import UserNotifications
import BackgroundTasks

struct ContentView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    
    @EnvironmentObject var  vm : QuestionViewModel
    
    var body: some View {
        NavigationView{
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.gray , .purple]), startPoint: .topLeading, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    if vm.questionsList.count > 0 {
                        List {
                            ForEach(vm.questionsList ) {  question in
                                ListCell(question: question)
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                        .navigationBarTitle("Questions List")
                        .navigationBarTitleDisplayMode(.inline)
                        
                    } else  {
                        Spacer()
                        Text("No Equations")
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    
                    NavigationLink(
                        
                        destination:
                            AddMathEquationView(question: QuestionModel())
                        ,
                        label: {
                        Text("Add Equation" )
                            .font(.system(size: 25, weight: .light, design:.default))
                            .foregroundColor(.black)
                    })
                    
                        .onAppear(perform: {
                            
                            // swiftUI
                            UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.sound,.alert]) { (_, _) in
                            }
                        })
                }
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ListCell: View {
    var question  : QuestionModel
    var body: some View {
        VStack {
            Text(" equation is : \(question.firstNumber ?? 0) \(question.operation.rawValue ) \(question.secondNumber ?? 0) = \(question.answer ?? "")" ).multilineTextAlignment(.center)
            if question.isShowLocation {
                Text("Location is : Lat \(question.latitude ?? 0.0) , lng \(question.longitude ?? 0.0)").multilineTextAlignment(.center)
            }
        }
    }
}
