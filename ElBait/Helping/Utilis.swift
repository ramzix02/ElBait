//
//  Utilis.swift
//  ElBait
//
//  Created by Ahmed Ramzy on 7/29/20.
//  Copyright © 2020 Ahmed Ramzy. All rights reserved.
//

import UIKit


// -MARK: Indicator

var activityInd = UIActivityIndicatorView()

enum IndicatorSwitch {
    case on
    case off
}

func indicatorSwitch(status: IndicatorSwitch,view: UIView) {
    switch status {
    case .on:
        //Show Indicator
        activityInd = showActivityIndicator(view: view)
        view.isUserInteractionEnabled = false
        break
    default:
        //Hide Indicator
        removeActivityIndicator(activityIndicator: activityInd)
        view.isUserInteractionEnabled = true
        break
    }
}

func showActivityIndicator(view: UIView) -> UIActivityIndicatorView{
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    activityIndicator.color = #colorLiteral(red: 0.1647058824, green: 0.168627451, blue: 0.2901960784, alpha: 0.8474154538)
    activityIndicator.center = view.center
    activityIndicator.startAnimating()
    view.addSubview(activityIndicator)
    return activityIndicator
}

func removeActivityIndicator(activityIndicator: UIActivityIndicatorView){
    activityIndicator.stopAnimating()
    activityIndicator.removeFromSuperview()
    
}

// -MARK: Views
class RoundTextField: UITextField {

    override func layoutSubviews() {
        super.layoutSubviews()
        borderStyle = .none
        layer.cornerRadius = bounds.height / 7
        layer.borderWidth = 1.0
        layer.borderColor = #colorLiteral(red: 0.8705882353, green: 0.8705882353, blue: 0.8705882353, alpha: 1)
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowRadius = 1
        layer.masksToBounds = false
        layer.shadowOpacity = 1.0
        layer.backgroundColor = UIColor.white.cgColor
    }
}

func setupTextField(textField: UITextField) {
    textField.leftView = UIView(frame: CGRect(x: 0,y: 0,width: 16,height: 0))
    textField.leftViewMode = .always
}

func makeRoundedCorners(view: UIView){
    view.layer.cornerRadius = 20.0
    view.clipsToBounds = true
    view.frame = view.frame.inset(by: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
}

func setUpRoundedBtn(btn:UIButton, color:UIColor)
{
    btn.backgroundColor = color
    btn.layer.cornerRadius = 7
    btn.clipsToBounds = true    
}

func showErrorAlert(title: String, errorMessage: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
    let action = UIAlertAction(title: "ok", style: .default)
    alert.addAction(action)
    return alert
}

func showToast(message : String, view: UIView) {
    
    let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 100, y: view.frame.size.height-100, width: 200, height: 35))
    toastLabel.backgroundColor = #colorLiteral(red: 0.2168715205, green: 0.2174777687, blue: 0.2421023348, alpha: 1).withAlphaComponent(1.0)
    toastLabel.textColor = UIColor.white
    toastLabel.textAlignment = .center;
    toastLabel.numberOfLines = 0
    toastLabel.font = UIFont(name: "Optima", size: 16.0)
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    toastLabel.adjustsFontSizeToFitWidth = true
    view.addSubview(toastLabel)
    UIView.animate(withDuration: 6.0, delay: 0.1, options: .curveEaseOut, animations: {
        toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
}

    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

func validateRegex(inputRegix: String, regixFormat: String) -> Bool{
    let regixPred =  NSPredicate(format:"SELF MATCHES %@", regixFormat)
    return regixPred.evaluate(with: inputRegix)
}



