//
//  MachineSwiftUIApp.swift
//  MachineSwiftUI
//
//  Created by Sherif Abd El-Moniem on 11/09/2021.
//

import SwiftUI
import BackgroundTasks

@main
struct MachineSwiftUIApp: App {

    @Environment(\.scenePhase) var scenePhase
    @ObservedObject var  vm : QuestionViewModel =  QuestionViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(vm)
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                print("App is active")
            case .inactive:
                print("App is inactive")
            case .background:
                print("App is in background")
            @unknown default:
                print("Oh - interesting: I received an unexpected new value.")
            }
        }
    }
}
