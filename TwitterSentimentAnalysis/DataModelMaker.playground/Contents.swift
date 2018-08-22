import Cocoa
import CreateML

let data = try MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/yasir/Desktop/iOS-App-Development/TwitterSentimentAnalysis/twitter-sanders-apple3.csv"))
let(trainingData, testingData) = data.randomSplit(by: 0.8, seed: 5)
let sentimentClassifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "class")
let evaluationMetrics = sentimentClassifier.evaluation(on: testingData)
let evaluationAccuracy = (1.0 - evaluationMetrics.classificationError) * 100
let metadata = MLModelMetadata(author: "Yasir Merchant", shortDescription: "Model trained to classify sentiment analysis on Tweets", version: "1.0")
try sentimentClassifier.write(to: URL(fileURLWithPath: "/Users/yasir/Desktop/iOS-App-Development/TwitterSentimentAnalysis/twitter-data-model.mlmodel"))
try sentimentClassifier.prediction(from: "Screw @Apple. I hate it")
try sentimentClassifier.prediction(from: "I love @Apple")
try sentimentClassifier.prediction(from: "@Apple needs to step their game up")
