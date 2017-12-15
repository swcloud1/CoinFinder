//
//  PopUpViewController.swift
//  CoinFinder
//
//  Created by Siwa Sardjoemissier on 10/12/2017.
//  Copyright © 2017 Siwa Sardjoemissier. All rights reserved.
//

import UIKit

protocol PopUpViewControllerDelegate {
    func popUpViewControllerDidChangeMarker(_ popUpViewController: PopUpViewController)
}

class PopUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var table: UITableView!

    
    @IBAction func DateAddedTapped(_ sender: Any) {
    }
    
    
//    static var dateSelected = false
//    static var tradeVolumeSelected = false
//    static var priceSelected = false
//    static var allSelected = false
//    static var noneSelected = false
    
    static var globalMarkers = [String]()
    static var markerBools = [Bool](arrayLiteral: false, false, false ,false, false)
    
    var row: Int = 0
    
    public var delegate: PopUpViewControllerDelegate?

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        
        let markerCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "markerCell")
        
        let markers = ["Date Added", "Trade Volume", "Dev. Activity", "All", "None"]
        
        markerCell.textLabel?.text = markers[indexPath.row]
        if PopUpViewController.markerBools[indexPath.row] == false {
            markerCell.accessoryType = .none
        } else {
            markerCell.accessoryType = .checkmark
        }
        return markerCell
    }
    
    func toggleCellCheckbox(_ cell: UITableViewCell) {
        
        if cell.accessoryType == .none {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        row = indexPath.row
        
        if row == 0 {
            if PopUpViewController.markerBools[row] == false {
                cell.accessoryType = .checkmark
                PopUpViewController.markerBools[row] = true
                PopUpViewController.globalMarkers.append("Date Added: ")
            } else {
                cell.accessoryType = .none
                PopUpViewController.markerBools[row] = false
                if let index = PopUpViewController.globalMarkers.index(of: "Date Added: ")
                {
                    PopUpViewController.globalMarkers.remove(at: index)
                }
            }
        }
        if row == 1 {
            if PopUpViewController.markerBools[row] == false {
                cell.accessoryType = .checkmark
                PopUpViewController.markerBools[row] = true
                PopUpViewController.globalMarkers.append("Trade Volume: ")

            } else {
                cell.accessoryType = .none
                PopUpViewController.markerBools[row] = false
                if let index = PopUpViewController.globalMarkers.index(of: "Trade Volume: ")
                {
                    PopUpViewController.globalMarkers.remove(at: index)
                }
            }
        }
        if row == 2 {
            if PopUpViewController.markerBools[row] == false {
                cell.accessoryType = .checkmark
                PopUpViewController.markerBools[row] = true
                PopUpViewController.globalMarkers.append("Dev. Activity: ")
            } else {
                cell.accessoryType = .none
                PopUpViewController.markerBools[row] = false
                if let index = PopUpViewController.globalMarkers.index(of: "Dev. Activity: ")
                {
                    PopUpViewController.globalMarkers.remove(at: index)
                }
            }
        }
        if row == 3 {
            if PopUpViewController.markerBools[row] == false {
                cell.accessoryType = .checkmark
                PopUpViewController.markerBools[0] = true
//                PopUpViewController.dateSelected = true
                PopUpViewController.markerBools[1] = true
//                PopUpViewController.priceSelected = true
                PopUpViewController.markerBools[2] = true
                PopUpViewController.markerBools[row] = true
                PopUpViewController.globalMarkers = ["Date Added: ", "Trade Volume: ", "Dev. Activity: "]
                table.reloadData()
            } else {
                PopUpViewController.markerBools[row] = false
                cell.accessoryType = .none
            }
        }
        if row == 4 {
            cell.accessoryType = .checkmark
            PopUpViewController.markerBools[row] = true
            PopUpViewController.markerBools[0] = false
            PopUpViewController.markerBools[1] = false
            PopUpViewController.markerBools[2] = false
            PopUpViewController.markerBools[3] = false
            PopUpViewController.markerBools[0] = false
            PopUpViewController.globalMarkers = [String]()
            cell.accessoryType = .none
            PopUpViewController.markerBools[row] = false
            table.reloadData()
        }
//        if TableViewController.cellsize == 3 {
////            PopUpViewController.allSelected = true
//        }
//        if TableViewController.cellsize > 3 {
//            TableViewController.cellsize = 3
//        }
        
        delegate?.popUpViewControllerDidChangeMarker(self)
    }
    
    
    @IBAction func comPlete(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    self.table.layer.borderWidth = 1

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
