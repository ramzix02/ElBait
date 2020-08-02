//
//  CompleteSignInVC.swift
//  ElBait
//
//  Created by Ahmed Ramzy on 7/29/20.
//  Copyright © 2020 Ahmed Ramzy. All rights reserved.
//

import UIKit
import Firebase

let notificationCtr = NotificationCenter.default
let broadcast = "broadcast"

class SignUpVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var txtFirstName: RoundTextField!
    @IBOutlet weak var txtLastName: RoundTextField!
    @IBOutlet weak var txtPassword: RoundTextField!
    @IBOutlet weak var txtCountryCode: RoundTextField!
    @IBOutlet weak var txtPhone: RoundTextField!
    @IBOutlet weak var btnSignUp: UIButton!
    
    // MARK: - Variables
    var userEmail: String?
    var dataAccess : NetworkHandler!
    private var viewModel : SignupViewModel!
    let userDefault = UserDefaults.standard
    var phoneNumber: String?
    var isVerified: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupObserver()
        }
    
    func setupObserver() {
        isVerified = false
        notificationCtr.addObserver(self, selector: Selector(("notifyObservers")), name: NSNotification.Name(rawValue: broadcast), object: nil)
    }
        
    // MARK: Observer Selector functions
    @objc func notifyObservers(){
        print("is verified")
        isVerified = true
        requestSignup()
    }
    
    deinit {
        notificationCtr.removeObserver(self)
    }

    func setupView() {
        setupTextField(textField: txtPassword)
        setupTextField(textField: txtPhone)
        setupTextField(textField: txtLastName)
        setupTextField(textField: txtFirstName)

        txtPassword.isSecureTextEntry = true
        setUpRoundedBtn(btn: btnSignUp, color: #colorLiteral(red: 0.02799758315, green: 0.3544191122, blue: 0.3496544957, alpha: 1))
    }
    
    @IBAction func signup(_ sender: Any) {
        dataAccess = NetworkHandler()
        viewModel = SignupViewModel(dataAccess:dataAccess)
                
        viewModel.userEmail = userEmail
        viewModel.userFName = txtFirstName.text ?? ""
        viewModel.userLName = txtLastName.text ?? ""
        viewModel.userPassword = txtPassword.text ?? ""
        viewModel.userPhone = txtPhone.text ?? ""
        viewModel.userCountryCode = txtCountryCode.text ?? ""
        
        if(viewModel.isValid){
            if !(isVerified ?? false) {
                btnSignUp.isEnabled = false
                verifyPhone()
                return
            }
            
        }else{
            indicatorSwitch(status: .off, view: view)
            showErrorMsg(msg: viewModel.brokenRules.first!.message)
        }
        
    }
    
    func verifyPhone() {
        guard let countryCode = txtCountryCode.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {return}
        guard let phone = txtPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {return}
       
        phoneNumber = countryCode + phone
        
        viewModel.verifyPhone(phoneNumber: phoneNumber ?? ""){
            success, error in
            if error == nil{
                showToast(message: "OTP sent successfully", view: self.view)
                self.goVerify()
            }else{
                self.showErrorMsg(msg: error?.localizedDescription ?? "")
            }
        }
    }
    
    func goVerify(){
        let vc = VerifyNumberVC()
        vc.phoneNumber = phoneNumber!
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func requestSignup() {
        indicatorSwitch(status: .on, view: view)
        viewModel.authenticateSignup { [weak self] (registerModel,error) in
            indicatorSwitch(status: .off, view: (self?.view)!)
            if let error = error {
                self?.showErrorMsg(msg: error.localizedDescription)
            }else{
                showToast(message: registerModel?.message ?? "", view: (self?.view)!)
            }
        }
    }
}





extension SignUpVC{
    @IBAction func showPassword(_ sender: Any) {
        if txtPassword.isSecureTextEntry{
            txtPassword.isSecureTextEntry = false
        } else {
            txtPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showErrorMsg(msg: String) {
        DispatchQueue.main.async { [weak self] in
        guard let self = self else{return}
        let alert = showErrorAlert(title: "Wrong!", errorMessage: msg)
        self.present(alert, animated: true, completion: nil)
        }
    }
}
