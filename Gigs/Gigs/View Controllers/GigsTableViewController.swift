//
//  GIgsTableViewController.swift
//  Gigs
//
//  Created by William Chen on 9/4/19.
//  Copyright © 2019 William Chen. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    var gigController = GigController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gigController.getAllGigNames()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
            
        }
        
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Custom Cell", for: indexPath)
        let gig = gigController.gigs[indexPath.row]
        cell.textLabel?.text = gig.title
        cell.detailTextLabel?.text = gig.description
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }else if segue.identifier == "ShowGig" {
                guard let detailVC = segue.destination as? GigDetailViewController,
                    let indexPath = tableView.indexPathForSelectedRow else {return}
                    detailVC.gig = gigController.gigs[indexPath.row]
                
                }
            }
        }
    }
    

