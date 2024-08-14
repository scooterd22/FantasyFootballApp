//
//  MatchupsViewController.swift
//  FantasyPlayers
//
//  Created by Scott DiBenedetto on 8/2/24.
//

import UIKit

class MatchupsViewController: UITableViewController {
    
    var leagues: [String?] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchupCell", for: indexPath)
        
        cell.textLabel?.text = leagues[indexPath.row]
        
        return cell
    }

}
