//
//  ViewController.swift
//  TwitterSentimentAnalysis
//
//  Created by Yasir Merchant on 2018-08-20.
//  Copyright © 2018 Yasir Merchant. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML

class ViewController: UIViewController
{
    let consumerKey = ""
    let consumerSecret = ""
    var swifter : Swifter!
    let tweetAnalyzer = twitter_data_model_1()
    
    @IBOutlet weak var inputTextLabel: UILabel!
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var emojiLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        swifter = Swifter(consumerKey: consumerKey, consumerSecret: consumerSecret)
    }
    
    private func changeEmoji(rating: Int)
    {
        print("rating is: \(rating)")
        if(rating > 20)
        {
            emojiLabel.text = "😍"
        }
        else if(rating > 10)
        {
            emojiLabel.text = "😃"
        }
        else if(rating > 0)
        {
            emojiLabel.text = "🙂"
        }
        else if(rating == 0)
        {
            emojiLabel.text = "😐"
        }
        else if(rating > -10)
        {
            emojiLabel.text = "🙁"
        }
        else if(rating > -20)
        {
            emojiLabel.text = "😡"
        }
        else
        {
            emojiLabel.text = "🤮"
        }
    }
    
    @IBAction func predictButtonPressed(_ sender: Any)
    {
        if let searchText = inputText.text
        {
            swifter.searchTweet(
                using: searchText,
                lang: "en",
                count: 100,
                tweetMode: .extended,
                success: { (results, metadata) in
                    
                    var tweets = [twitter_data_model_1Input]()
                    for i in 0..<100
                    {
                        if let tweet = results[i]["full_text"].string
                        {
                            tweets.append(twitter_data_model_1Input(text: tweet))
                        }
                    }
                    
                    do
                    {
                        var rating : Int = 0
                        let predictions = try self.tweetAnalyzer.predictions(inputs: tweets)
                        for prediction in predictions
                        {
                            let score = prediction.label
                            
                            if(score == "Pos")
                            {
                                rating += 1
                            }
                            else if(score == "Neg")
                            {
                                rating -= 1
                            }
                        }
                        
                        self.changeEmoji(rating: rating)
                    }
                    catch
                    {
                        print(error)
                    }
                },
                failure: { (error) in
                    print("an error occurred \(error)")
            })
        }
    }
}

