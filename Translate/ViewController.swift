//
//  ViewController.swift
//  Translate
//
//  Created by Robert O'Connor on 16/10/2015.
//  Copyright © 2015 WIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet weak var textToTranslate: UITextView!
    
    @IBOutlet weak var translatedText: UITextView!
    
    @IBOutlet weak var picker: UIPickerView!
   
    @IBOutlet weak var test: UILabel!
    
    @IBOutlet var output: UIButton!
    
    @IBOutlet weak var translate: UIButton!
    
        
    @IBOutlet weak var input: UILabel!
    
    

    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        
        picker.isHidden=true
        test.isHidden=true
        output.setTitle("French", for: UIControlState.normal)
        
        output.layer.cornerRadius = 4
        textToTranslate.layer.cornerRadius = 4
        translatedText.layer.cornerRadius = 4
        translate.layer.cornerRadius = 4
        input.layer.cornerRadius = 4
                
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DestViewController : SecondViewController = segue.destination as! SecondViewController
    }
    
    @IBAction func buttonPressed(_ sender: AnyObject) {
        
        picker.isHidden=false
        textToTranslate.text = ""
    }
    
    
    
    var langStr = " "
    var outputLanguage = ["French", "Turkish", "Irish"]
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return outputLanguage.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return outputLanguage[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        picker.isHidden = true;
        test.text = outputLanguage[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
   
    
    
    func getOutputLanguage() -> String{
        if (test.text == "French"){
            langStr = ("en|fr")
            output.setTitle("French", for: UIControlState.normal)

        }
        else if (test.text == "Turkish"){
            langStr = ("en|tr")
            output.setTitle("Turkish", for: UIControlState.normal)

                    }
        else if(test.text == "Irish"){
            langStr = ("en|ga")
            output.setTitle("Irish", for: UIControlState.normal)

        }
        
        //default to french
        else{
            langStr = ("en|fr")
            output.setTitle("French", for: UIControlState.normal)
            
        }
        print ("language is " + test.text!)
        print ("Its actually " + langStr)
                return langStr
    }
    
    
    
    
    

    
    
    
    
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
     
        textToTranslate.resignFirstResponder()
       
        
    }
    
    
    @IBAction func translate(_ sender: AnyObject) {
        let str = textToTranslate.text
        let escapedStr = str?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let langStr = getOutputLanguage().addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        
        let urlStr:String = ("https://api.mymemory.translated.net/get?q="+escapedStr!+"&langpair="+langStr)
        
        let url = URL(string: urlStr)
        
        let session = URLSession.shared
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        var result = "<Translation Error>"
        
                session.dataTask(with: url!){
            (data, response, error) in
            
            EZLoadingActivity.hide(true, animated: true)
            
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode == 200){
                    
                    let jsonDict: NSDictionary = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    
                    if(jsonDict.value(forKey: "responseStatus") as! NSNumber == 200){
                        let responseData: NSDictionary = jsonDict.object(forKey: "responseData") as! NSDictionary
                        
                        result = responseData.object(forKey: "translatedText") as! String
                    }
                    
                }
            }
            DispatchQueue.main.async {
                EZLoadingActivity.hide(false, animated: true)
                self.translatedText.text = result
            }
        }.resume()
    }
    

            
            
    
  
        
}

