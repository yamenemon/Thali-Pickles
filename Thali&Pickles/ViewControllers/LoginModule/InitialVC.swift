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
        kroyBtn.reshapedButton()
        bikroyBtn.reshapedButton()
    }
    
    @IBAction func kroyBtnAction(_ sender: Any) {
        loadLoginVC()
    }
    @IBAction func bikroyBtnAction(_ sender: Any) {
        loadLoginVC()
    }
    func loadLoginVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tbc = storyboard.instantiateViewController(withIdentifier:"loginController")
        self.navigationController?.pushViewController(tbc, animated: true)
    }
    @IBAction func termsAndPolicyBtnAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "tnc_storyboard")
        vc.modalTransitionStyle = .flipHorizontal
        self.present(vc, animated: true)
    }
}







