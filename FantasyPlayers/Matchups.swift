//
//  Matchups.swift
//  FantasyPlayers
//
//  Created by Scott DiBenedetto on 8/4/24.
//
import UIKit

class Matchups: UITableViewCell {
    
    @IBOutlet weak var league: UILabel!
    
    @IBOutlet weak var teamOneScore: UILabel!
    @IBOutlet weak var teamNameOne: UILabel!
    @IBOutlet weak var teamNameTwo: UILabel!
    @IBOutlet weak var teamTwoScore: UILabel!
    
    @IBOutlet weak var teamTwoImage: UIImageView!
    @IBOutlet weak var teamOneImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getPoints() async throws -> Points{
        let endpoint = "https://api.sleeper.app/v1/league/<league_id>/matchups/<week>"
        guard let url = URL(string: endpoint) else {
            throw SleeperError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw SleeperError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Points.self, from: data)
            
            
        }catch{
            throw SleeperError.invalidData
            
        }
    
    }
    
    
}
