//
//  UITableViewController.swift
//  CoinFinder
//
//  Created by Siwa Sardjoemissier on 04/12/2017.
//  Copyright © 2017 Siwa Sardjoemissier. All rights reserved.
//

import UIKit
//import Firebase
//import FirebaseDatabaseUI

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PopUpViewControllerDelegate{
    
    
    @IBOutlet weak var resultAmount: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBAction func markersPressed(_ sender: UIButton) {
        let popUpViewController: PopUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController
        popUpViewController.delegate = self
        self.present(popUpViewController, animated: true, completion: nil)
    }
    
    // refresh button
    @IBAction public func cellSizePressed(_ sender: Any) {
        table.reloadData()
    }
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    

    // Int to keep track of size of Cells
    static var cellsize = 0
    // array of coinNames and CoinDates as Strings
    var coinName = [String]()
    var coinDate = [String]()
    // empty array of Coin-structs
    var coins = [Coin]()
    var coin: Coin?
//    var ref: DatabaseReference!
    
    // function to fetsh data and fill coin-array
    func downloadCoinInfo(finished: @escaping () -> Void) {
        
        var coinAmount = 0
        
        let url = URL(string: "https://bittrex.com/api/v1.1/public/getmarkets")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            
            if error != nil {
                
                print(error!)
                
            } else {
                
                if let urlContent = data {
                    
                    do {
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        
                        if jsonResult["result"] is NSArray {
                            let JSONCoins = jsonResult["result"] as! NSArray
                        
                            // Get Amount of Coins in API Results
                            coinAmount = JSONCoins.count - 1
                            print(coinAmount)
                        }
                        
                        for i in 0...coinAmount {
                            if let coinresult = ((jsonResult["result"] as? NSArray)?[i] as? NSDictionary){
                                
                                var coin: Coin?
                                
                                // get coin name
                                let name = (coinresult).value(forKey: "MarketCurrencyLong")
                                
                                // get coin creation date
                                let created = (coinresult).value(forKey: "Created") as? String
                                let index = created?.index(of: "T")!
                                let dateCreated = String(created![..<index!])
                                
                                // only save coins that are paired with BTC
                                let base = (coinresult).value(forKey: "BaseCurrencyLong") as? String
                                if base == "Bitcoin" {
                                    coin = Coin(name: name as? String, dateCreated: dateCreated, volume: nil, commits: nil)
                                    print("\(String(describing: coin?.name)) was added on: \(String(describing: coin?.dateCreated))")
                                    self.coins.append(coin!)
                                }
                            }
                        }
                        
                    } catch {
                        
                        print("JSON Processing Failed")
                        
                    }
                    
                }
                // Completion Marker
                finished()
            }
            
        }
        task.resume()
    }
    
    // set amount of rows for table
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //       Eerste Versie: if coinName.count < 1 {
//        if coins.count < 1 {
//            downloadCoinInfo(){
//                self.table.reloadData()
//            }
//        }
        return self.coins.count
    }
    
    // adjust cell size
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        if TableViewController.cellsize == 0 {
//            return 44.0
//        }
//        else if TableViewController.cellsize == 1 {
//            return 61.0
//        }
//        else if TableViewController.cellsize == 2 {
//            return 77.0
//        }
//        else if TableViewController.cellsize == 3 {
//            return 95.0
//        }
//        self.table.reloadData()
//        return 44.0
//    }
    
    // Fill Cells With Coins and Markers
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        cell.contentView.addSubview(label)
        
        let constraints = [
            label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: 10),
            label.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -10),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        var lines = PopUpViewController.globalMarkers
        
        if let index = PopUpViewController.globalMarkers.index(of: "Date Added: ")
        {
            lines[index] = "Date Added: " + coins[indexPath.row].dateCreated!
        }
//        if let index = PopUpViewController.globalMarkers.index(of: "Dev. Activity: ")
//        {
//            PopUpViewController.globalMarkers.remove(at: index)
//        }
        lines.insert(coins[indexPath.row].name!, at: 0)
        
        label.text = lines.joined(separator: "\n")
        label.numberOfLines = 0
        return cell
        
//        // Naam + 1 Markers
//        if TableViewController.cellsize == 1 {
//            // 1 Marker: Marker 1
//            let secondLabel = UILabel()
//            secondLabel.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
//            secondLabel.textAlignment = .left
//            if PopUpViewController.globalMarkers[0] == "Date Added: "
//            {
//                secondLabel.text = PopUpViewController.globalMarkers[0] + coins[indexPath.row].dateCreated!
//            }
//            else
//            {
//                secondLabel.text = PopUpViewController.globalMarkers[0]
//            }
//            secondLabel.tag = indexPath.row
//            cell.contentView.addSubview(secondLabel)
//            secondLabel.translatesAutoresizingMaskIntoConstraints = false
//            secondLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
//            secondLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
//            secondLabel.centerXAnchor.constraint(equalTo: secondLabel.superview!.centerXAnchor).isActive = false
//            secondLabel.leadingAnchor.constraint(equalTo: secondLabel.superview!.leadingAnchor, constant: 16).isActive = true
//            secondLabel.centerYAnchor.constraint(equalTo: secondLabel.superview!.centerYAnchor, constant: 16).isActive = true
//            // 1 Marker: CoinName
//            cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false
//            cell.textLabel?.centerXAnchor.constraint(equalTo: (cell.textLabel?.superview!.centerXAnchor)!).isActive = false
//            cell.textLabel?.leadingAnchor.constraint(equalTo: (cell.textLabel?.superview!.leadingAnchor)!, constant: 16).isActive = true
//            cell.textLabel?.centerYAnchor.constraint(equalTo: (cell.textLabel?.superview!.centerYAnchor)!, constant: -8).isActive = true
//
//        }
//
//        // Naam + 2 Markers
//        if TableViewController.cellsize == 2 {
//            // 2 Markers: Marker 1
//            let secondLabel = UILabel()
//            secondLabel.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
//            secondLabel.textAlignment = .left
//            if PopUpViewController.globalMarkers[0] == "Date Added: "
//            {
//                secondLabel.text = PopUpViewController.globalMarkers[0] + coins[indexPath.row].dateCreated!
//            }
//            else
//            {
//                secondLabel.text = PopUpViewController.globalMarkers[0]
//            }
//            secondLabel.tag = indexPath.row
//            cell.contentView.addSubview(secondLabel)
//            secondLabel.translatesAutoresizingMaskIntoConstraints = false
//            secondLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
//            secondLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
//            secondLabel.centerXAnchor.constraint(equalTo: secondLabel.superview!.centerXAnchor).isActive = false
//            secondLabel.leadingAnchor.constraint(equalTo: secondLabel.superview!.leadingAnchor, constant: 16).isActive = true
//            secondLabel.centerYAnchor.constraint(equalTo: secondLabel.superview!.centerYAnchor, constant: 0).isActive = true
//            // 2 Markers: Marker 2
//            let thirdLabel = UILabel()
//            thirdLabel.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
//            thirdLabel.textAlignment = .left
//            if PopUpViewController.globalMarkers[1] == "Date Added: "
//            {
//                thirdLabel.text = PopUpViewController.globalMarkers[1] + coins[indexPath.row].dateCreated!
//            }
//            else
//            {
//                thirdLabel.text = PopUpViewController.globalMarkers[1]
//            }
//            thirdLabel.tag = indexPath.row
//            cell.contentView.addSubview(thirdLabel)
//            thirdLabel.translatesAutoresizingMaskIntoConstraints = false
//            thirdLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
//            thirdLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
//            thirdLabel.centerXAnchor.constraint(equalTo: thirdLabel.superview!.centerXAnchor).isActive = false
//            thirdLabel.leadingAnchor.constraint(equalTo: thirdLabel.superview!.leadingAnchor, constant: 16).isActive = true
//            thirdLabel.centerYAnchor.constraint(equalTo: thirdLabel.superview!.centerYAnchor, constant: 20).isActive = true
//            // 2 Markers: CoinName
//            cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false
//            cell.textLabel?.centerXAnchor.constraint(equalTo: (cell.textLabel?.superview!.centerXAnchor)!).isActive = false
//            cell.textLabel?.leadingAnchor.constraint(equalTo: (cell.textLabel?.superview!.leadingAnchor)!, constant: 16).isActive = true
//            cell.textLabel?.centerYAnchor.constraint(equalTo: (cell.textLabel?.superview!.centerYAnchor)!, constant: -20).isActive = true
//
//        }
//
//        // Naam + 3 Markers
//        if TableViewController.cellsize == 3 {
//            // 3 Markers: Marker 1
//            let secondLabel = UILabel()
//            secondLabel.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
//            secondLabel.textAlignment = .left
//            if PopUpViewController.globalMarkers[0] == "Date Added: "
//            {
//                secondLabel.text = PopUpViewController.globalMarkers[0] + coins[indexPath.row].dateCreated!
//            }
//            else
//            {
//                secondLabel.text = PopUpViewController.globalMarkers[0]
//            }
//            secondLabel.tag = indexPath.row
//            cell.contentView.addSubview(secondLabel)
//            secondLabel.translatesAutoresizingMaskIntoConstraints = false
//            secondLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
//            secondLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
//            secondLabel.centerXAnchor.constraint(equalTo: secondLabel.superview!.centerXAnchor).isActive = false
//            secondLabel.leadingAnchor.constraint(equalTo: secondLabel.superview!.leadingAnchor, constant: 16).isActive = true
//            secondLabel.centerYAnchor.constraint(equalTo: secondLabel.superview!.centerYAnchor, constant: -8).isActive = true
//            // 3 Markers: Marker 2
//            let thirdLabel = UILabel()
//            thirdLabel.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
//            thirdLabel.textAlignment = .left
//            if PopUpViewController.globalMarkers[1] == "Date Added: "
//            {
//                thirdLabel.text = PopUpViewController.globalMarkers[1] + coins[indexPath.row].dateCreated!
//            }
//            else
//            {
//                thirdLabel.text = PopUpViewController.globalMarkers[1]
//            }
//            thirdLabel.tag = indexPath.row
//            cell.contentView.addSubview(thirdLabel)
//            thirdLabel.translatesAutoresizingMaskIntoConstraints = false
//            thirdLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
//            thirdLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
//            thirdLabel.centerXAnchor.constraint(equalTo: thirdLabel.superview!.centerXAnchor).isActive = false
//            thirdLabel.leadingAnchor.constraint(equalTo: thirdLabel.superview!.leadingAnchor, constant: 16).isActive = true
//            thirdLabel.centerYAnchor.constraint(equalTo: thirdLabel.superview!.centerYAnchor, constant: 16).isActive = true
//            // 3 Markers: Marker 3
//            let fourthLabel = UILabel()
//            fourthLabel.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
//            fourthLabel.textAlignment = .left
//            fourthLabel.text = PopUpViewController.globalMarkers[2]
//            if PopUpViewController.globalMarkers[2] == "Date Added: "
//            {
//                fourthLabel.text = PopUpViewController.globalMarkers[2] + coins[indexPath.row].dateCreated!
//            }
//            else
//            {
//                fourthLabel.text = PopUpViewController.globalMarkers[2]
//            }
//            fourthLabel.tag = indexPath.row
//            cell.contentView.addSubview(fourthLabel)
//            fourthLabel.translatesAutoresizingMaskIntoConstraints = false
//            fourthLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
//            fourthLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
//            fourthLabel.centerXAnchor.constraint(equalTo: fourthLabel.superview!.centerXAnchor).isActive = false
//            fourthLabel.leadingAnchor.constraint(equalTo: fourthLabel.superview!.leadingAnchor, constant: 16).isActive = true
//            fourthLabel.centerYAnchor.constraint(equalTo: fourthLabel.superview!.centerYAnchor, constant: 38).isActive = true
//            // 3 Markers: CoinName
//            cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false
//            cell.textLabel?.centerXAnchor.constraint(equalTo: (cell.textLabel?.superview!.centerXAnchor)!).isActive = false
//            cell.textLabel?.leadingAnchor.constraint(equalTo: (cell.textLabel?.superview!.leadingAnchor)!, constant: 16).isActive = true
//            cell.textLabel?.centerYAnchor.constraint(equalTo: (cell.textLabel?.superview!.centerYAnchor)!, constant: -34).isActive = true
//        }
        
        // fill Tablecells if Coinarray has Content
//        if coins.count < 1 {
//            table.reloadData()
////            cell.textLabel?.text = ""
//        }
//        else {
//            cell.textLabel?.text = coins[indexPath.row].name
//        }
//        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        let alert = UIAlertController(title: "Add This Coin to Your List: ",
                                      message: cell.textLabel?.text,
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        
                    let coin = self.coins[indexPath.row]
                                        
//                    let coinRef = self.ref.child((coin.name?.lowercased())!)
//
//                    coinRef.setValue(coin.toAnyObject())
                                        
                    UserCoinsViewController.userCoins.append(coin)
//                                print(UserCoinsViewController.userCoins)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
//        print(UserCoinsViewController.userCoins)
    }
    
    func popUpViewControllerDidChangeMarker(_ popUpViewController: PopUpViewController) {
        table.reloadData()
    }
    
    // setup main view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.rowHeight = UITableViewAutomaticDimension
        self.table.estimatedRowHeight = 50

//        ref = Database.database().reference()
        if self.coins.count < 1 {
            downloadCoinInfo(){
                print(self.coins)
                        self.resultAmount.text = "\(self.coins.count) matches"
            }
        }
    }
 
    override func viewDidAppear(_ animated: Bool) {
        self.table.reloadData()
        reloadInputViews()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



