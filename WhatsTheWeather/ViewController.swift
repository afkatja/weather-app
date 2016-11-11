//
//  ViewController.swift
//  WhatsTheWeather
//
//  Created by Katja Hollaar on 11/11/2016.
//  Copyright © 2016 Katja Hollaar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var cityInput: UITextField!
    @IBOutlet weak var cityOutput: UILabel!
    @IBOutlet weak var weatherText: UILabel!
    var city = ""
    @IBAction func lookupCity(_ sender: Any) {
        city = cityInput.text ?? ""
        cityOutput.text = city.capitalized
        city = city.trimmingCharacters(in: .whitespacesAndNewlines)
        if (city.contains(" ")) {
            city = city.replacingOccurrences(of: " ", with: "-")
        }
        if city != "" {
            if let url = URL(string: "http://www.weather-forecast.com/locations/\(city.lowercased())/forecasts/latest") {
                let request = NSMutableURLRequest(url: url)
                let task = URLSession.shared.dataTask(with: request as URLRequest) {
                    data, response, error in
                    if error != nil {
                        self.weatherText.text = "Sorry, weather for this city could not be found"
                    } else {
                        var weatherSummary = ""
                        if let unwrappedData = data {
                            let datastring = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                            let separator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                            let endSeparator = "</span>"
                            if let summary = datastring?.components(separatedBy: separator) {
                                if summary.count > 1 {
                                    let theSummary = summary[1].components(separatedBy: endSeparator)
                                    if theSummary.count > 1 {
                                        weatherSummary = theSummary[0]
                                        weatherSummary = try! self.convertHtmlSymbols(str: weatherSummary)!
                                    }
                                }
                            }
                            DispatchQueue.main.sync(execute: {
                                // Update UI
                                self.weatherText.text = weatherSummary
                            })
                        }
                    }
                }
                task.resume()
            } else {
                weatherText.text = "Sorry, we couldn't find the weather for this place. Please try again?"
            }
        } else {
            weatherText.text = "Please enter a city name"
        }
    }
    
    func convertHtmlSymbols(str: String) throws -> String? {
        guard let data = str.data(using: .utf8) else { return nil }
        
        return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil).string
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cityInput.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        let url = URL(string: "https://images.unsplash.com/photo-1461906903741-bf21de16ae85")
        let data = NSData(contentsOf: url!)
        if data != nil {
            bgImage.image = UIImage(data: data as! Data)
            bgImage.contentMode = UIViewContentMode.scaleAspectFill
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

