//
//  SignInPasswordVC.swift
//  ElBait
//
//  Created by Ahmed Ramzy on 7/29/20.
//  Copyright © 2020 Ahmed Ramzy. All rights reserved.
//

import UIKit

class SignInPasswordVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var txtPassword: RoundTextField!
    @IBOutlet weak var btnShow: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    // MARK: - Variables
    var userEmail: String?
    var dataAccess : NetworkHandler!
    private var viewModel : LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        setupTextField(textField: txtPassword)
        txtPassword.isSecureTextEntry = true
        setUpRoundedBtn(btn: btnLogin, color: #colorLiteral(red: 0.02799758315, green: 0.3544191122, blue: 0.3496544957, alpha: 1))
    }
    
    @IBAction func goLogin(_ sender: Any) {
        dataAccess = NetworkHandler()
        viewModel = LoginViewModel(dataAccess:dataAccess)
        viewModel.userEmail = userEmail
        viewModel.userPassword = txtPassword.text ?? ""
       
        if(viewModel.isPasswordValid){
            indicatorSwitch(status: .on, view: view)
            viewModel.authenticatePassword { [weak self] (loginModel,error) in
                indicatorSwitch(status: .off, view: (self?.view)!)
                if let error = error {
                    self?.showErrorMsg(msg: error.localizedDescription)
                }else{
                    showToast(message: loginModel?.message ?? "", view: (self?.view)!)
                }
            }
        }else{
            indicatorSwitch(status: .off, view: view)
            showErrorMsg(msg: viewModel.brokenRules.first!.message)
        }
    }
    
    @IBAction func showPassword(_ sender: Any) {
        if txtPassword.isSecureTextEntry{
            txtPassword.isSecureTextEntry = false
        } else {
            txtPassword.isSecureTextEntry = true
        }
    }
}






extension SignInPasswordVC{
    
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
