//
//  InitialVC.swift
//  Thali&Pickles
//
//  Created by Emon on 2/8/20.
//  Copyright © 2020 TriTechFirm. All rights reserved.
//

import UIKit

class InitialVC: UIViewController {

    @IBOutlet weak var kroyBtn: UIButton!
    @IBOutlet weak var bikroyBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
        reshapedButton(btn: kroyBtn)
        reshapedButton(btn: bikroyBtn)
    }
    
    func reshapedButton(btn:UIButton) {
        btn.layer.cornerRadius = 8.0
        btn.layer.masksToBounds = false
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.gray.cgColor
        btn.layer.shadowColor = UIColor.darkGray.cgColor
        btn.layer.shadowOpacity = 0.8
        btn.layer.shadowRadius = 2
        btn.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
    }
    
    @objc func chekBtnClicked(sender:UIButton) {

    }
    
    @IBAction func kroyBtnAction(_ sender: Any) {
        
    }
    @IBAction func bikroyBtnAction(_ sender: Any) {
        
    }
    @IBAction func termsAndPolicyBtnAction(_ sender: Any) {
        
//        let tncController = tncVC()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "tnc_storyboard")
        self.present(vc, animated: true)
        
    }
}







