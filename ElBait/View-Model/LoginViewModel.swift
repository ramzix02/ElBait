//
//  LoginViewModel.swift
//  ElBait
//
//  Created by Ahmed Ramzy on 7/30/20.
//  Copyright © 2020 Ahmed Ramzy. All rights reserved.
//

import Foundation

enum CheckLogin{
    case login
    case register
}

struct LoginBrokenRule {
    var propertyName : String
    var message : String
}

class LoginViewModel{
    
// MARK: - Variables
private let url: String = "http://asmio.innsandbox.com/api/customer/check"
private let urlPassword: String = "http://asmio.innsandbox.com/api/customer/login?token=true"
var userEmail : String!
var userPassword : String!
var brokenRules: [LoginBrokenRule] = [LoginBrokenRule]()
var dataAccess : NetworkHandler!
    
var isEmailValid: Bool {
    get{
        self.brokenRules.removeAll()
        self.validateEmail()
        return brokenRules.count == 0
    }
}

var isPasswordValid: Bool {
    get{
        self.brokenRules.removeAll()
        self.validatePassword()
        return brokenRules.count == 0
    }
}
    
init(dataAccess:NetworkHandler) {
    self.dataAccess = dataAccess
}
 
    func validateEmail(){
        if(!(userEmail.isEmpty)){
            if(!(isValidEmail(email: userEmail))){
                self.brokenRules.append(LoginBrokenRule(propertyName: "User Email", message: "Please enter a valid Email Address"))
            }
        }else{
            self.brokenRules.append(LoginBrokenRule(propertyName: "User Email", message: "An email address must be provided."))
        }
    }
    func validatePassword(){
        if(!(userPassword.isEmpty)){
            if(userPassword.count < 6){
                self.brokenRules.append(LoginBrokenRule(propertyName: "User Password", message: "please enter a valid password"))
            }
        }else{
            self.brokenRules.append(LoginBrokenRule(propertyName: "User password", message: "Please enter your password."))
        }
    }

    private func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func authenticateEmail(completion: @escaping(CheckLogin?, Error?)-> Void){
            
        dataAccess.excuteEmailRequest(url: url, dic:
            ["email": userEmail
        ]){
            
        checkEmail , error in
        
        let code = Int(checkEmail?.code ?? "0")
        let msg = checkEmail?.message ?? ""
        
        if(code ?? 0 >= 200 || code ?? 0 <= 299){
                if msg == "Exists" {
                    completion(.login,nil)
                }else if msg == "Register"{
                    completion(.register,nil)
                }
        }
        
        if(error != nil){
            completion(nil,error)
        }
    }
    }
    
    func authenticatePassword(completion: @escaping(LoginModel?, Error?)-> Void) {
        
        dataAccess.excutePasswordRequest(url: urlPassword, dic:
                ["email": userEmail,
                 "password": userPassword
            ]){
                
            loginModel , error in
             
            if (loginModel?.code != nil){
                completion(loginModel,nil)
            }
            if(error != nil){
                 completion(nil,error)
                }
        }
    }
}
