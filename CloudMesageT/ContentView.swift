//
//  ContentView.swift
//  CloudMesageT
//
//  Created by Michele Manniello on 18/07/21.
//

import SwiftUI

struct ContentView: View {
    @State var notificationTitle : String = ""
    @State var notificationContent : String = ""
    let legacyServerKey = "AAAAv8EDt48:APA91bGauFLDqxk0kLLG40CTKt0NbZOAOBYzb7tIuymQNdBCjzV8z_NwEH6uA2djaiOi4jub07UrSHbkLjGr5dFlCDqqndlScUzAvvpIXgFc7wxt6Wy2-3_6eSR4IU0aeOIPXrWwKCVv"
    var body: some View {
        VStack{
            Text("Invia notifiche")
                .font(.title)
            TextField("Add notification Title",text: $notificationTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(20)
            TextField("Add notification Content", text: $notificationContent)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(20)
            Button(action: {
                sendMessageTouser(to: "fqLPzx4QKEYMtu0QuorWhl:APA91bGQIBi4aFgurdedtF2U-lTNDddPBYk_Z2Wq8MNJ6ajt3iC4Z0biDZD4telvMMN4000jMaJEztERwzXM6dG1pkF4I9d0GYSRk-V9SrxdrOhMLcsVh2GlqmOdXlk8B8dUFZ2fGhE0", title: notificationTitle, body: notificationContent)
            }, label: {
                Text("Send Message to user")
                    
            })
            .padding()
            Spacer()
        }
    }
    func sendMessageTouser(to token: String, title: String, body: String) {
          print("sendMessageTouser()")
          let urlString = "https://fcm.googleapis.com/fcm/send"
          let url = NSURL(string: urlString)!
          let paramString: [String : Any] = [
            "to" : token,
            "notification" : ["title" : title, "body" : body,"sound":"default"],
            "data" : ["user" : "test_id"]
          ]
//        let paramString : [String: Any] = [
//            "to": "allDevices",
//            "notification" : ["title" : title, "body" : body],
//            "data" : ["user" : "test_id"]
//            ]
        
          let request = NSMutableURLRequest(url: url as URL)
          request.httpMethod = "POST"
          request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
          request.setValue("application/json", forHTTPHeaderField: "Content-Type")
          request.setValue("key=\(legacyServerKey)", forHTTPHeaderField: "Authorization")
          let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
              do {
                  if let jsonData = data {
                      if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                          NSLog("Received data:\n\(jsonDataDict))")
                      }
                  }
              } catch let err as NSError {
                  print(err.debugDescription)
              }
          }
          task.resume()
      }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
