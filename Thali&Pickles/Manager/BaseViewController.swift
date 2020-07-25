//
//  BaseViewController.swift
//  WorkersApp
//
//  Created by Islam Md. Zahirul on 11/3/20.
//  Copyright © 2020 OC Lab Limited. All rights reserved.
//

import UIKit
import SwiftSpinner

class BaseViewController: UIViewController {
    
    private var isSetForegroundView: Bool = false
    private var _foregroundKeyboardView: UIView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHideNavBar(isHidden: true)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK:- Getter
    var foregroundKeyboardView:UIView {
        if _foregroundKeyboardView == nil {
            _foregroundKeyboardView = UIView(frame: CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: SIZE_HEIGHT))
            let tapView: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(BaseViewController.hideForegroundKeyboardView))
            _foregroundKeyboardView!.addGestureRecognizer(tapView)
            _foregroundKeyboardView!.isHidden = true
        }
        return _foregroundKeyboardView!
    }
    
    //MARK:- Public method
    func addForegroundKeyboard(parentView:UIView) {
        if isSetForegroundView == false {
            parentView.addSubview(self.foregroundKeyboardView)
            isSetForegroundView = true
        }
    }
    
    @objc func hideForegroundKeyboardView() {
        self.setEditing(false, animated: false)
        
    }
    func showForegroundKeyboardView() {
        self.foregroundKeyboardView.isHidden = false
    }
    
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func setHideNavBar(isHidden: Bool){
        self.navigationController?.isNavigationBarHidden = isHidden
    }
    
    
    // MARK: - SwiftSpinner
    @objc func hideHUDProgress() {
        SwiftSpinner.hide()
    }
    
    func showHUDProgress(_ withAlert:Bool? = true) {
        if let _withAlert = withAlert,_withAlert {
            SwiftSpinner.show("Loading")
        } else {
            SwiftSpinner.hide()
        }
    }
    
    func showAlertWithMessage(headerText:String,message:String){
        
        let alertController = UIAlertController(title: headerText, message: message, preferredStyle: .alert)
        
        let action2 = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction) in
            print("You've pressed cancel");
        }
        
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
    func showToastAtWindow(text : String){
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            window.makeToast(text, duration: 30, position: .bottom, title: "", image: nil, style: .init(), completion: nil)
        }
    }
    /*
    @objc func cardBtnAction(sender: UIButton) {
        UIView.animate(withDuration: TimeInterval(0.1), delay: 0.0, options: [], animations: {
            sender.alpha = 0.5
        }) { finished in
            sender.alpha = 1.0
            
            let carWorkerVC = CardWorkerVC()
            carWorkerVC.modalPresentationStyle = .fullScreen
            if !WorkerManager.sharedInstance().isLoggedIn() {
                carWorkerVC.shopDataArr = []
                self.present(carWorkerVC, animated: true, completion: nil)
                return
            }
            
            ProgressHUD.shared.show()
            AppNetworkManager._singletonInstance.getShopsHaveWorkerCard(onSuccess: { (response, nextUrl) in
                ProgressHUD.shared.hide()
                DispatchQueue.main.async {
                    carWorkerVC.nextUrl = nextUrl
                    carWorkerVC.shopDataArr = response
                    self.present(carWorkerVC, animated: true, completion: nil)
                }
            }) { (error) in
                self.displayMessage(message: error?.message)
            }
        }
    }
    
    @objc func notifyBtnAction(sender: UIButton) {
        UIView.animate(withDuration: TimeInterval(0.1), delay: 0.0, options: [], animations: {
            sender.alpha = 0.5
        }) { finished in
            sender.alpha = 1.0
            let vc = TopSeeMoreVC()
            self.navigationController?.pushViewController(vc,animated: true)
        }
        
    }
    */
    
}
