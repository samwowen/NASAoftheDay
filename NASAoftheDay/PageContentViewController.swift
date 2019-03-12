//
//  ViewController.swift
//  NASAoftheDay
//
//  Created by Sam Owen on 23/01/2019.
//  Copyright © 2019 EskiSoftware. All rights reserved.
//

import UIKit
import Foundation

class PageContentViewController: UIViewController {
    @IBOutlet weak var TitleDate: UILabel!
    @IBOutlet weak var NasaImage: ScaledHeightImageView!
    @IBOutlet weak var Explanation: UITextView!
    
    var apiDate : String = "";
    var dateOffset : Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetDateLabel()
        SetImage()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func SetDateLabel() {
        // Can use the api formatter stuff if I want to not use the default date
        let date = Date.init(timeIntervalSinceNow: TimeInterval(86400 * dateOffset))
        let apiFormatter = DateFormatter()
        let displayFormatter = DateFormatter()
        
        apiFormatter.dateFormat = "yyyy-MM-dd"
        displayFormatter.dateFormat = "MMM dd,yyyy"
        
        let result = displayFormatter.string(from: date)
        apiDate = apiFormatter.string(from: date)
        
        TitleDate.text = result
    }
    
    func SetImage() {
        // Make up the request URL
        var requestString : String = ""
        if (apiDate == "" || dateOffset == 0) {
            requestString = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY"
        } else {
            requestString = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&date=" + apiDate
        }
        
        // Set the URL the request is being made to.
        let request = URLRequest(url: NSURL(string: requestString)! as URL)
        do {
            // Perform the request
            let response: AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
            let data = try NSURLConnection.sendSynchronousRequest(request, returning: response)
            
            // Convert the data to JSON
            let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            
            if let json = jsonSerialized, let url = json["url"], let explanation = json["explanation"] {
                
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: URL(string: url as! String)!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        let image = UIImage(data: data!)
                        self.NasaImage.image = image
                    }
                }
                Explanation.text = explanation as? String
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}

