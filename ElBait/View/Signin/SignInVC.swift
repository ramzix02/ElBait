//
//  SignInVC.swift
//  ElBait
//
//  Created by Ahmed Ramzy on 7/29/20.
//  Copyright © 2020 Ahmed Ramzy. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var txtEmail: RoundTextField!
    @IBOutlet weak var btnSignIn: UIButton!
    
    // MARK: - Variables
    var dataAccess : NetworkHandler!
    private var viewModel : LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    
    func setUpView() {
        setupTextField(textField: txtEmail)
        makeRoundedCorners(view: popupView)
        setUpRoundedBtn(btn: btnSignIn, color: #colorLiteral(red: 0.02799758315, green: 0.3544191122, blue: 0.3496544957, alpha: 1))
    }
    
    @IBAction func checkEmail(_ sender: Any) {
        let email = txtEmail.text ?? ""

        dataAccess = NetworkHandler()
        viewModel = LoginViewModel(dataAccess:dataAccess)
        viewModel.userEmail = email
        
        if(viewModel.isEmailValid){
            indicatorSwitch(status: .on, view: view)
            viewModel.authenticateEmail { [weak self] (checkLogin,error) in
                indicatorSwitch(status: .off, view: (self?.view)!)
                if let error = error {
                    self?.showErrorMsg(msg: error.localizedDescription)
                }else{
                    switch  checkLogin{
                    case .login:
                        self?.goLogin(email: email)
                        break
                    case .register:
                        self?.goRegister(email: email)
                        break
                    default:
                        break
                    }
                }
            }
        }else{
            indicatorSwitch(status: .off, view: view)
            showErrorMsg(msg: viewModel.brokenRules.first!.message)
        }
    }
}





extension SignInVC{
    
    @IBAction func loginWithFB(_ sender: Any) {
        
    }
    
    func goLogin(email: String){
        let vc = SignInPasswordVC()
        vc.userEmail = email
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    func goRegister(email: String){
        let vc = SignUpVC()
        print("your email is \(email)")
        vc.userEmail = email
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func showErrorMsg(msg: String) {
        DispatchQueue.main.async { [weak self] in
        guard let self = self else{return}
        let alert = showErrorAlert(title: "Wrong!", errorMessage: msg)
        self.present(alert, animated: true, completion: nil)
        }
    }

    
}

