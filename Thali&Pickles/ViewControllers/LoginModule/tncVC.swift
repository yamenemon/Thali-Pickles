//
//  tncVC.swift
//  Thali&Pickles
//
//  Created by Emon on 2/8/20.
//  Copyright © 2020 TriTechFirm. All rights reserved.
//

import UIKit
import PDFKit

class tncVC: UIViewController {
    
    @IBOutlet weak var pdfContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillLayoutSubviews() {
        let pdfView = PDFView()
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfContainerView.addSubview(pdfView)
        
        pdfView.leadingAnchor.constraint(equalTo: pdfContainerView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: pdfContainerView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: pdfContainerView.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: pdfContainerView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        pdfView.autoresizesSubviews = true
        pdfView.displayDirection = .vertical
        pdfView.autoScales = false
        pdfView.displayMode = .singlePageContinuous
        pdfView.displaysPageBreaks = true
        pdfView.maxScaleFactor = 4.0
        pdfView.minScaleFactor = pdfView.scaleFactorForSizeToFit
        
        guard let path = Bundle.main.url(forResource: "tnc", withExtension: "pdf") else { return }
        
        if let document = PDFDocument(url: path) {
            pdfView.document = document
        }
    }
    @IBAction func closeBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
