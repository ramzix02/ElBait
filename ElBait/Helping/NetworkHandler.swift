//
//  NetworkHandler.swift
//  ElBait
//
//  Created by Ahmed Ramzy on 7/29/20.
//  Copyright © 2020 Ahmed Ramzy. All rights reserved.
//

import Foundation
import Alamofire

class NetworkHandler  {

    func excuteEmailRequest(url: String,dic: [String : String], completionHandler: @escaping(CheckEmail?, Error?)-> Void){
                
        AF.request(url, method: .post, parameters:
            dic)
            .responseJSON{ (response) in
            do{
                 if(response.data != nil){
                    
                    let checkEmail = try JSONDecoder().decode(CheckEmail.self, from: response.data!)
                
                    completionHandler(checkEmail,nil)
                 }
                 else if((response.error) != nil){
                    completionHandler(nil,response.error)
                }
            }
            catch{
                print(error.localizedDescription)
                }
            }
        }
    
    func excutePasswordRequest(url: String,dic: [String : String], completionHandler: @escaping(LoginModel?, Error?)-> Void){
            
    AF.request(url, method: .post, parameters:
        dic)
        .responseJSON{ (response) in
        do{
             if(response.data != nil){
                
                let loginModel = try JSONDecoder().decode(LoginModel.self, from: response.data!)
            print(loginModel)
                completionHandler(loginModel,nil)
             }
             else if((response.error) != nil){
                completionHandler(nil,response.error)
            }
        }
        catch{
            completionHandler(nil,error)
            }
        }
    }
    
    func excuteSignupRequest(url: String,dic: [String : String], completionHandler: @escaping(RegisterModel?, Error?)-> Void){
            
    AF.request(url, method: .post, parameters:
        dic)
        .responseJSON{ (response) in
        do{
             if(response.data != nil){
                
                let loginModel = try JSONDecoder().decode(RegisterModel.self, from: response.data!)
            print(loginModel)
                completionHandler(loginModel,nil)
             }
             else if((response.error) != nil){
                completionHandler(nil,response.error)
            }
        }
        catch{
            completionHandler(nil,error)
            }
        }
    }
}
