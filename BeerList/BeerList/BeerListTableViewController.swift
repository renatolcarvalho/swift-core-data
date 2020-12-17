//
//  BeerListTableViewController.swift
//  BeerList
//
//  Created by Renato Luiz Carvalho on 15/12/20.
//

import UIKit
import CoreData

class BeerListTableViewController: UITableViewController {

    var context : NSManagedObjectContext!
    var beers : [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    func getBeers(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BeerList")
        let order = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [order]
        
        do {
            let beers =  try context.fetch(request)
            self.beers = beers as! [NSManagedObject]
            self.tableView.reloadData()
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getBeers()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.beers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let beer = self.beers[indexPath.row]
        let text = beer.value(forKey: "text")
        let date = beer.value(forKey: "date")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm"
        
        let formattedDate = dateFormatter.string(from: date as! Date)
        
        cell.textLabel?.text = String(describing: text)
        cell.detailTextLabel?.text = String(describing: formattedDate)

        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let beer = self.beers[indexPath.row]
        self.performSegue(withIdentifier: "openBeer", sender: beer)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openBeer" {
            let viewBeer = segue.destination as! ViewController
            viewBeer.beer = sender as? NSManagedObject
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            let beer = self.beers[indexPath.row]
            self.context.delete(beer)
            self.beers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            do {
                try self.context.save()
            } catch let error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
