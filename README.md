# MachineSwiftUI
VA Task
Implement an app and a background service, both of which work together as follows: 
  
Background Service: 
1- It is a math engine service that runs all the time in the background. It is designed to receive Math Question from the app. 
2- A Math Question includes variable number of parameters, one operator {Add,Sub,Mul,Div} and time to receive response. Time to receive response is a scheduled task managed by the background service, which only send a response (Math Answer response) to the app based on the specified value. 
3- Following the point above, there must be a pool or queue mechanism that manage and executes equations as scheduled tasks. 
  
App: 
1- The app allows a user to enter a basic mathematical question.  
2- The app allows a user to determine the delay time; i.e. 5 seconds, 30 seconds, and so on. 
3- Upon hitting a button (calculate), the math equation will be sent to the background service to operate in scheduler as described above. 
4- There must be a panel that shows operations that are pending execution. 
5- There must be a panel that shows operation results received from the background service. 
6- There must be an option to view location information i.e. GPS. 
  
Other Requirements: 
1- Make sure to test your app and background service on both iOS and Android. 
2- Provide a build script to run your app on both iOS and Android. Provide two profiles, one for QA and the other of Prod. 
3- Provide analysis and profiling for the battery and memory leaks and usage of both app and background service. 
4- Provide unit and instrumentation tests. 
