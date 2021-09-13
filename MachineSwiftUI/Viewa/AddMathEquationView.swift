//
//  AddMathEquationView.swift
//  MachineSwiftUI
//
//  Created by Sherif Abd El-Moniem on 11/09/2021.
//


import SwiftUI
import CoreLocation
import CoreLocationUI

struct AddMathEquationView : View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let locationFetcher = LocationFetcher()
    
    @EnvironmentObject var  vm : QuestionViewModel
    
    @StateObject var question : QuestionModel
    
    
    var body: some View {
        VStack {
            Text("Add Question" )
                .font(.system(size: 35, weight: .bold, design:.default))
                .foregroundColor(.red)
                .padding(.top, 50)
            Spacer()
            
            NumberField(sfSymbolName: "number", placeHolder: "first number", prompt: question.firstNumberPrompt, field: $question.firstNumber)
            
            NumberField(sfSymbolName: "number", placeHolder: "second number", prompt: question.secondNumberPrompt, field: $question.secondNumber)
            
      Text("choose an operator \(question.operation.rawValue)")
                .padding()
                .contextMenu {
                    ForEach(OprationsEnum.allCases, id: \.self){ operation in
                        Button(action: {
                            self.changeOperator(operation: operation)}) {
                                Text(operation.rawValue)
                            Image(systemName: "checkmark.circle.fill")
                        }
                    }.font(.title)
    
            
                }
            
            
            .padding()
            NumberField(sfSymbolName: "number", placeHolder: "delay", prompt: "" , field: $question.delayTime)
            
            Toggle(isOn: $question.isShowLocation, label: {
                EmptyView()
            }) .fixedSize()
                .onChange(of: question.isShowLocation) { value in
                    if value {
                        self.locationFetcher.start()
                    }
                }
            Button {
                if question.isShowLocation {
                    if let location = self.locationFetcher.lastKnownLocation {
                        print("Your location is \(location)")
                        self.question.latitude = location.latitude
                        self.question.longitude = location.longitude
                    } else {
                        print("Your location is unknown")
                    }
                }
                trigerService()
                DispatchQueue.main.async {
                    self.presentationMode.wrappedValue.dismiss()
                }
            } label: {
                Text("Calculate" )
                    .font(.system(size: 25, weight: .light, design:.default))
                    .foregroundColor(.black)
            }
            .opacity(question.isQuestionMissing ? 1 : 0.6)
            .disabled(!question.isQuestionMissing)
            Spacer()
        }
        .padding([.trailing  , . leading])
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
        
    }
       func changeOperator( operation : OprationsEnum){
    self.question.operation = operation
}
       func trigerService(){
    let dispatchAfter = DispatchTimeInterval.seconds(self.question.delayTime!)
    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + dispatchAfter) {
        getAnswer()
    }
}
func getAnswer(){
    if self.question.operation == .Sum {
        let result = (question.firstNumber ?? 0) + (question.secondNumber ?? 0)
        question.answer = String(result)
    } else if  self.question.operation == .Sub {
        let result = (question.firstNumber ?? 0) - (question.secondNumber ?? 0)
        question.answer = String(result)
    }
    else if  self.question.operation == .Multiply {
        let result = (question.firstNumber ?? 0) * (question.secondNumber ?? 0)
        question.answer = String(result)
        
    }else if  self.question.operation == .Devide {
        let result = (question.firstNumber ?? 0) / (question.secondNumber ?? 0)
        question.answer = String(result)
        
    }
    DispatchQueue.main.async {
        self.vm.questionsList.append(question)
        self.Notify()
    }
}
func Notify(){
    let content = UNMutableNotificationContent()
    content.title = "Message"
    content.body = "your equation has bes solved successfully"
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    let req = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
}
}
struct NumberField: View {
    var sfSymbolName: String
    var placeHolder: String
    var prompt: String
    
    @Binding var field: Int?
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: sfSymbolName)
                    .foregroundColor(.gray)
                    .font(.headline)
                
                TextField(placeHolder, text: Binding(
                    get: { field != nil ?  String(field!) : ""  },
                    set: { field = Int($0)}
                )).autocapitalization(.none)
                    .keyboardType(.numberPad)
            }
            .padding(8)
            .background(Color(UIColor.secondarySystemBackground))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
            Text(prompt)
                .background(Color(UIColor.secondarySystemBackground))
                .fixedSize(horizontal: false, vertical: true)
                .font(.caption)
        }
    }
}
class LocationFetcher: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var lastKnownLocation: CLLocationCoordinate2D?
    override init() {
        super.init()
        manager.delegate = self
    }
func start() {
    manager.requestWhenInUseAuthorization()
    manager.startUpdatingLocation()
}
func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    lastKnownLocation = locations.first?.coordinate
}
}

// didnt used
class LocationViewModel : NSObject, ObservableObject , CLLocationManagerDelegate {
    var manager : CLLocationManager?
func checkIfLocationServicesIsEnabled(){
    if CLLocationManager.locationServicesEnabled() {
        manager = CLLocationManager()
        manager?.delegate = self
    }else{
        // TODO :- alert
        print("location service is off please turn it on")
    }
}
    private func checkLocationAuthorization(){
        guard let manager = manager else { return }
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        case .authorizedAlways ,  .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
    }
func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    checkLocationAuthorization()
}
}
