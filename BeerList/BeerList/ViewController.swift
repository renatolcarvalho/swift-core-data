//
//  ViewController.swift
//  BeerList
//
//  Created by Renato Luiz Carvalho on 15/12/20.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var text: UITextView!
    var context : NSManagedObjectContext!
    var beer : NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.text.becomeFirstResponder()
        
        if beer != nil{
            if let textRetrieved = beer.value(forKey: "text"){
                self.text.text = String(describing: textRetrieved)
            }
        }
        else
        {
            self.text.text = ""
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }

    @IBAction func newBeerButton(_ sender: Any) {
        
        if (beer == nil){
            self.save()
        }
        else
        {
            self.update()
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func save(){
        let newBeer = NSEntityDescription.insertNewObject(forEntityName: "BeerList", into: context)
        
        newBeer.setValue(self.text.text, forKey: "text")
        newBeer.setValue(Date(), forKey: "date")
        
        do {
            try context.save()
            print("Saved")
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func update(){
        
        beer.setValue(self.text.text, forKey: "text")
        beer.setValue(Date(), forKey: "date")
        
        do {
            try context.save()
            print("Updated")
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
   
}

