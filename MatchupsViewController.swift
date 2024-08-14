//
//  MatchupsViewController.swift
//  FantasyPlayers
//
//  Created by Scott DiBenedetto on 8/2/24.
//

import UIKit

class MatchupsViewController: UITableViewController {
    var leagueNames: [Leagues] = []
    var rosterIDs: [RosterID] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "Matchups", bundle: nil), forCellReuseIdentifier: "MatchupCell")
        
        

        // Do any additional setup after loading the view.
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagueNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchupCell", for: indexPath) as! Matchups
        
        cell.league.text = leagueNames[indexPath.row].name
//        cell.teamOneScore.text = String(rosterIDs[1].roster_id)
        
        return cell
    }
    
//    func getRosterID(leagueID: String) async throws -> [RosterID]{
//        var endpoint = "https://api.sleeper.app/v1/league/"
//        endpoint.append("\(leagueID)"  + "/rosters")
//        print(endpoint)
//        
//        guard let url = URL(string: endpoint) else {
//            throw SleeperError.invalidURL
//        }
//        
//        let (data, response) = try await URLSession.shared.data(from: url)
//        
//        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//            throw SleeperError.invalidResponse
//        }
//        
//        do {
//            let decoder = JSONDecoder()
//            return try decoder.decode([RosterID].self, from: data)
//            
//            
//        }catch{
//            throw SleeperError.invalidData
//            
//        }
//    }

}
