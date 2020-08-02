////
////  SignInViewModel.swift
////  ElBait
////
////  Created by Ahmed Ramzy on 7/29/20.
////  Copyright © 2020 Ahmed Ramzy. All rights reserved.
////
////aaaaaaasssssss@gmail.com
//import Foundation
//
////enum CheckLogin{
////    case login
////    case register
////}
//
//class SignInViewModel: NSObject {
//    
//    private let url: String = "http://asmio.innsandbox.com/api/customer/check"
//    
//    override init() {
//        super.init()
//
//    }
//    
//    func validateInputs(email: String) -> Bool {
//     if(email.count == 0){
//        //showToast(message: "Please enter E-Mail", view: self.view)
//        return false
//    }else if !validateRegex(inputRegix: email, regixFormat: emailRegEx){
//        //showToast(message: "Please enter a valid E-Mail", view: self.view)
//        return false
//    }
//        return true
//    }
//    
//    func checkEmailExists(email: String) {
//        
//        if validateInputs(email: email){
//            
//        NetworkHandler.excuteRequest(url: url, dic:
//            ["email": email
//        ]){
//            
//        checkEmail , error in
//
//        //indicatorSwitch(status: .off, view: self.view)
//        
//        let code = Int(checkEmail?.code ?? "0")
//        let msg = checkEmail?.message ?? ""
//        
//        
//            if(code ?? 0 >= 200 || code ?? 0 <= 299){
//
//                if msg == "Exists" {
//                    self.redirectUser(check: .login)
//                }else if msg == "Register"{
//                    self.redirectUser(check: .register)
//                }
//            
//        }else{
//                print("Code is not \(code ?? 0)")
//            return
//        }
//        
//        if(error != nil){
//            print("There is an ERROR")
//        }
//    }
//    }
//    }
//    
//    func redirectUser(check: CheckLogin) {
////        switch check {
////        case .login:
////            notificationCtr.post(name: NSNotification.Name(rawValue: broadcastLogin), object: self)
////            break
////        case .register:
////            notificationCtr.post(name: NSNotification.Name(rawValue: broadcastRegister), object: self)
////            break
////        }
//    }
//    
//    deinit {
//        //notificationCtr.removeObserver(self)
//    }
//}
