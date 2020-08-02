//
//  SignupViewModel.swift
//  ElBait
//
//  Created by Ahmed Ramzy on 7/30/20.
//  Copyright © 2020 Ahmed Ramzy. All rights reserved.
//

import Foundation
import Firebase

struct SignUpBrokenRule{
    var name:String
    var message:String
    
}

class SignupViewModel{
    
    // MARK: - Variables
    private let url: String = "http://asmio.innsandbox.com/api/customer/register"
    var userFName : String!
    var userLName : String!
    var userEmail : String!
    var userPassword : String!
    var userPhone : String!
    var userCountryCode : String!
        
    var brokenRules: [SignUpBrokenRule] = [SignUpBrokenRule]()
    var dataAccess : NetworkHandler!
    let userDefault = UserDefaults.standard
    
    var isValid: Bool{
        get{
            self.brokenRules = [SignUpBrokenRule]()
            self.validate()
            return self.brokenRules.count == 0 ? true : false
        }
    }
    
    init(dataAccess:NetworkHandler) {
        self.dataAccess = dataAccess
    }
    
    func authenticateSignup(completion: @escaping(RegisterModel?, Error?)-> Void) {
        
        dataAccess.excuteSignupRequest(url: url, dic:
                ["first_name":userFName,
                 "last_name":userLName,
                 "email": userEmail,
                 "password": userPassword,
                 "phone":userPhone,
                 "country_code": userCountryCode
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
    
    func verifyPhone(phoneNumber: String,completion: @escaping(Bool?, Error?)-> Void) {
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber , uiDelegate:nil ){

            (verificationId, error) in

            if error == nil{
                guard let verifyId = verificationId else {return}
                self.saveVerificationID(verifyId: verifyId)
                
                completion(true,nil)
            }else{
                completion(false,error)
                print("unable to get secret verification code from Firebase")
            }
        }
    }
    
    func verifyOTP(otpCode: String,completion: @escaping(Bool?, Error?)-> Void) {
        let credentials = PhoneAuthProvider.provider().credential(withVerificationID: getVerificationID() ?? "" , verificationCode: otpCode)
        
        Auth.auth().signInAndRetrieveData(with: credentials){
        success, error in
        if error == nil{
            notificationCtr.post(name: NSNotification.Name(rawValue: broadcast), object: self)
            completion(true,nil)
        }else{
            completion(false,error)
            }
        }
    }
    
    deinit {
        notificationCtr.removeObserver(self)
    }
    
    func saveVerificationID(verifyId: String) {
        userDefault.set(verifyId, forKey: "verificationId")
        userDefault.synchronize()
    }
    
    func getVerificationID() -> String?{
        return userDefault.string(forKey: "verificationId")
    }
}

//MARK: - Validation
extension SignupViewModel{
   
    private func validate()
    {
        self.validateUsername(name: userFName, type: "First Name")
        self.validateUsername(name: userLName, type: "Last Name")
        self.validatePassword()
        self.validatePhone()
    }

    private func validateUsername(name: String, type: String){
        if (name.isEmpty){
            self.brokenRules.append(SignUpBrokenRule(name:type,message:"\(type) must be provided."))
        }
        else
        {
            let usernameRegEX = "^(?=.{4,20}$)(?![0-9._])(?!.*[_.]{2})[a-zA-Z0-9._\\u0621-\\u064A ]+(?<![_.])$";
            let usernamePred = NSPredicate(format:"SELF MATCHES %@",usernameRegEX )
            if (!usernamePred.evaluate(with: name))
            {
                self.brokenRules.append(SignUpBrokenRule(name:"Username",
                                                         message:"\(type) must start of letter and be between 4 and 20 characters."))
            }
        }
    }

    private func validatePassword(){
        if(userPassword.isEmpty || userPassword.count<6)
        {
            self.brokenRules.append(SignUpBrokenRule(name:"Password",message:"The password must be 6 characters long or more."))
        }
    }

    private func validatePhone()
    {
        if(self.userPhone.isEmpty)
        {
            self.brokenRules.append(SignUpBrokenRule(name:"phone",message: "Please enter your phone number."))
        }else {
            let phoneRegex = "^[1]\\d{9}$"
            let phonePred = NSPredicate(format:"SELF MATCHES %@",phoneRegex)
            if (!phonePred.evaluate(with: userPhone))
            {
                self.brokenRules.append(SignUpBrokenRule(name:"phone",message: "Phone number is badly formatted."))
            }
        }
    }
}
