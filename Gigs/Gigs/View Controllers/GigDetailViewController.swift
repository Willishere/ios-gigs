//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by William Chen on 9/5/19.
//  Copyright © 2019 William Chen. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var gigController: GigController?
    
    var gig: Gig?{
        didSet{
            updateViews()
        }
    }
    
    func updateViews(){
        guard let gig = gig else {return}
        
        jobTitleTextField.text = gig.title
        datePicker.date = gig.dueDate
        descriptionTextView.text = gig.description
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        guard let gigController = gigController, let title = jobTitleTextField.text, let description = descriptionTextView.text
        else {return}
        
        gigController.createGig(with: Gig(title: title, description: description, dueDate: datePicker.date)) { _ in
            self.dismiss(animated: true, completion: nil)
        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
}
