//
//  ViewController.swift
//  FantasyPlayers
//
//  Created by Scott DiBenedetto on 7/24/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var timeTaken: UILabel!
    @IBOutlet weak var invalidLabel: UILabel!
    @IBOutlet weak var year: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rosterNumber: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    var leagues: [Leagues] = []
    var roster_ID: [RosterID] = []
    var matchupID: [MatchupID] = []
    var loading = true
    var rosterIDDict: [String: Int] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
       
    }
    
        //finds the user
    func getUser() async throws -> User{
        var endpoint = "https://api.sleeper.app/v1/user/"
        endpoint.append(usernameField.text!)
        
        guard let url = URL(string: endpoint) else {
            throw SleeperError.invalidURL
        }
        
        // the get request
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // makes sure it isnt a 404 error
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw SleeperError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            //invalidLabel.text = "User found!"
            return try decoder.decode(User.self, from: data)
            
            
        }catch{
            let alert = UIAlertController(title: "User not found", message: "try a different user", preferredStyle: .alert)
            
            let dismiss = UIAlertAction(title: "Dismiss", style: .default)
            
            alert.addAction(dismiss)
            self.present(alert, animated: true)
            
            throw SleeperError.invalidData
            
        }
        
    }
    
    //gets the leagues they are in based off their used id that is passed in
    func getRosterNumber(userID: String) async throws -> [Leagues]{
        var endpoint = "https://api.sleeper.app/v1/user/"
        endpoint.append(userID)
        endpoint.append("/leagues/nfl/")
        endpoint.append(year.text ?? "2024")
        print(endpoint)
        
        guard let url = URL(string: endpoint) else {
            throw SleeperError.invalidURL
        }
        
        // the get request
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // makes sure it isnt a 404 error
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw SleeperError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Leagues].self, from: data)
            
            
        }catch{
            throw SleeperError.invalidData
        }
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        
        
        Task {
            do {
                let user = try await getUser()
                DispatchQueue.main.async {
                    self.usernameLabel.text = user.user_id
                }
                // here i am getting the league ids to get the roster ids
                let leagues = try await getRosterNumber(userID: user.user_id!)
                
                
                //update based off what is found
                DispatchQueue.main.async {
                    self.leagues = leagues
                    // ui being updated
                    self.rosterNumber.text = "Total leagues: \(leagues.count)"
                    self.tableView.reloadData()
                }
                
                
                let startThree = DispatchTime.now()
                for league in leagues {
                    print(leagues.count)
                    print(league.league_id!)
         
                    async let rosterID = self.getRosterID(leagueID: league.league_id!)
                    
                    
                    let matchupID = try await self.getMatchupID(leagueID: league.league_id!)

                    for matchup in matchupID {
                        print(matchup) // print each matchup individually
                    }

                    
                    for roster in try await rosterID {
                        if user.user_id == roster.owner_id {
                            
//                            print("Roster ID: \(String(describing: roster.roster_id))
                            //holds the key value pair of league id and the
                            rosterIDDict[roster.league_id!] = roster.roster_id
                        }
                    }
                    
                }
                
//                print(rosterIDDict)
//                print(rosterIDDict.count)
                let endThree = DispatchTime.now()
                let equationAnswer = (Double(endThree.uptimeNanoseconds)/1000000000.0) - (Double(startThree.uptimeNanoseconds)/1000000000.0)
                timeTaken.text = String(equationAnswer)
                
                
                
            } catch {
                // Handle the error here
                print(error)
            }
        }
    }
    
    
    @IBAction func playerDataPressed(_ sender: Any) {
      
        
    }
    
    func getRosterID(leagueID: String) async throws -> [RosterID]{
        var endpoint = "https://api.sleeper.app/v1/league/"
        endpoint.append("\(leagueID)"  + "/rosters")
//        print(endpoint)
        
        guard let url = URL(string: endpoint) else {
            throw SleeperError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw SleeperError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([RosterID].self, from: data)
            
            
        }catch{
            throw SleeperError.invalidData
            
        }
    }
    
    //matchup id call
    func getMatchupID(leagueID: String) async throws -> [MatchupID] {
        var endpoint = "https://api.sleeper.app/v1/league/"
        endpoint.append("\(leagueID)" + "/matchups/1")
        
        guard let url = URL(string: endpoint) else {
            throw SleeperError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw SleeperError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([MatchupID].self, from: data)
            
            
        }catch{
            throw SleeperError.invalidData
            
        }
        
        
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MatchupSegue" {
            if let destinationVC = segue.destination as? MatchupsViewController {
                destinationVC.leagueNames = leagues
                destinationVC.rosterIDs = roster_ID
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return leagues.count
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        cell.textLabel?.text = leagues[indexPath.row].name
        return cell
     
    }
    
    
}



//                    let rosterID = try await getRosterID(leagueID: league.league_id!)
//                    for roster in rosterID {
//                        print("Roster ID: \(String(describing: rosterID.roster_id))")
