//
//  VerifyNumberVC.swift
//  ElBait
//
//  Created by Ahmed Ramzy on 7/29/20.
//  Copyright © 2020 Ahmed Ramzy. All rights reserved.
//

import UIKit
import Firebase

class VerifyNumberVC: UIViewController, UITextFieldDelegate {

    // MARK: - Outlets
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var txtOTP1: RoundTextField!
    @IBOutlet weak var txtOTP2: RoundTextField!
    @IBOutlet weak var txtOTP3: RoundTextField!
    @IBOutlet weak var txtOTP4: RoundTextField!
    @IBOutlet weak var txtOTP5: RoundTextField!
    @IBOutlet weak var txtOTP6: RoundTextField!
    
    @IBOutlet weak var lblPhone: UILabel!
    let userDefault = UserDefaults.standard
    var phoneNumber: String?
    var dataAccess : NetworkHandler!
    private var viewModel : SignupViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        setUpRoundedBtn(btn: btnVerify, color: #colorLiteral(red: 0.02799758315, green: 0.3544191122, blue: 0.3496544957, alpha: 1))
        
        txtOTP1.delegate = self
        txtOTP2.delegate = self
        txtOTP3.delegate = self
        txtOTP4.delegate = self
        txtOTP5.delegate = self
        txtOTP6.delegate = self
        
        txtOTP1.addTarget(self, action: #selector(self.textdidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOTP2.addTarget(self, action: #selector(self.textdidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOTP3.addTarget(self, action: #selector(self.textdidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOTP4.addTarget(self, action: #selector(self.textdidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOTP5.addTarget(self, action: #selector(self.textdidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOTP6.addTarget(self, action: #selector(self.textdidChange(textField:)), for: UIControl.Event.editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lblPhone.text = "Enter the code sent to \(phoneNumber!)"
        txtOTP1.becomeFirstResponder()
        
        dataAccess = NetworkHandler()
        viewModel = SignupViewModel(dataAccess:dataAccess)
    }
    
    @objc func textdidChange(textField: UITextField){
        let text = textField.text
        
        if text?.utf16.count == 1{
            switch textField {
            case txtOTP1:
                txtOTP2.becomeFirstResponder()
                break
            case txtOTP2:
                txtOTP3.becomeFirstResponder()
                break
            case txtOTP3:
                txtOTP4.becomeFirstResponder()
                break
            case txtOTP4:
                txtOTP5.becomeFirstResponder()
                break
            case txtOTP5:
                txtOTP6.becomeFirstResponder()
                break
            case txtOTP6:
                txtOTP6.resignFirstResponder()
                break
            default:
                break
            }
        }
    }
    
    @IBAction func goVerify(_ sender: Any) {
        verifyOTP()
    }
    
    func verifyOTP() {
        
        let otpCode = ("\(txtOTP1.text ?? "")\(txtOTP2.text ?? "")\(txtOTP3.text ?? "")\(txtOTP4.text ?? "")\(txtOTP5.text ?? "")\(txtOTP6.text ?? "")")
            
        viewModel.verifyOTP(otpCode: otpCode){
            success, error in
            if error == nil{
                showToast(message: "Verification Done", view: self.view)
                self.dismiss(animated: true, completion: nil)
            }else{
                self.showErrorMsg(msg: error?.localizedDescription ?? "")
            }
        }
    }
    
    @IBAction func resendOTP(_ sender: Any) {
        clearTxtFields()
        viewModel.verifyPhone(phoneNumber: phoneNumber ?? ""){
        success, error in
        if error == nil{
            
            showToast(message: "OTP sent successfully", view: self.view)
        }else{
            self.showErrorMsg(msg: error?.localizedDescription ?? "")
        }
        }
        
    }
}





extension VerifyNumberVC{
    
    func clearTxtFields() {
        txtOTP1.text = ""
        txtOTP2.text = ""
        txtOTP3.text = ""
        txtOTP4.text = ""
        txtOTP5.text = ""
        txtOTP6.text = ""
    }
    
    @IBAction func btnBack(_ sender: Any) {
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
