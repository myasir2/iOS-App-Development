//
//  ViewController.swift
//  TwitterSentimentAnalysis
//
//  Created by Yasir Merchant on 2018-08-20.
//  Copyright © 2018 Yasir Merchant. All rights reserved.
//

import UIKit
import SwifteriOS

class ViewController: UIViewController
{
    let swifter = Swifter(consumerKey: "DX3fo5lB8lLm56ahwRzmiCOED", consumerSecret: "S9YtQsDSjhddkgFshuGuJjXGye9xEF58j3HGvI7rFcg87OXHiQ")
    
    @IBOutlet weak var inputTextLabel: UILabel!
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var emojiLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func predictButtonPressed(_ sender: Any)
    {
        
    }
}

