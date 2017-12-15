//
//  TestViewController.swift
//  CoinFinder
//
//  Created by Siwa Sardjoemissier on 04/12/2017.
//  Copyright © 2017 Siwa Sardjoemissier. All rights reserved.
//

import UIKit
import Firebase

class UserCoinsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    public static var userRef: DatabaseReference?
    var coinNames = [String]()
    
    @IBOutlet weak var table: UITableView!
    
    static var userCoins = [Coin]() {
        didSet {
            let coinRef = UserCoinsViewController.userRef?.child((UserCoinsViewController.userCoins.last?.name?.lowercased())!)
            coinRef?.setValue(UserCoinsViewController.userCoins.last?.toAnyObject());
            
            
        }
    }
    
    @IBAction func SignOutPressed(_ sender: UIButton) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.performSegue(withIdentifier: "signOutSegue", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        return self.coinNames.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "itemCell")

        cell.textLabel?.text = self.coinNames[indexPath.row]

        return cell
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        Auth.auth().addStateDidChangeListener() { auth, user in}
        Auth.auth().addStateDidChangeListener() { auth, user in
            UserCoinsViewController.userRef?.observeSingleEvent(of: .value, with: { (snapshot) in
                
                let dictionary = snapshot.value as? NSDictionary
                
                var coins = [String]()
                dictionary?.forEach({ (arg: (key: Any, value: Any)) in
                    
                    let (key, _) = arg
                    coins.append(key as! String)
                })
                
                self.coinNames = coins
                self.table.reloadData()
            })
        }
    }
    
}
