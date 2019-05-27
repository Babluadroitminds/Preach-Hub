//
//  TermsNConditionViewController.swift
//  Preach Hub
//
//  Created by Sajeev S L on 24/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit

class TermsNConditionViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHtmlFile()
        webView.scrollView.bounces = false
    }
    
    func loadHtmlFile() {
        let url = Bundle.main.url(forResource: "terms", withExtension:"html")
        let request = NSURLRequest(url: url!)
        webView.loadRequest(request as URLRequest)
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
