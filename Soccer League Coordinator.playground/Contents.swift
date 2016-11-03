//  Manually create a single collection that contains all information for all 18 players. 
//  Each player should themselves be represented by their own collection.

//  Name	Height (inches)	Soccer Experience	Guardian Name(s)
//  Joe Smith	42	YES	Jim and Jan Smith


var players: [[String: (height: Int, experience: Bool, guardians: String)]] = [
    ["Joe Smith": (42, true, "Jim and Jan Smith")],
    ["Jill Tanner": (36, true, "Clara Tanner")],
    ["Bill Bon": (43, true, "Sara and Jenny Bon")],
    ["Eva Gordon": (45, false, "Wendy and Mike Gordon")],
    ["Matt Gill": (40, false, "Charles and Sylvia Gill")],
    ["Kimmy Stein": (41, false, "Bill and Hillary Stein")],
    ["Sammy Adams": (45, false, "Jeff Adams")],
    ["Karl Saygan": (42, true, "Heather Bledsoe")],
    ["Suzane Greenberg": (44, true, "Henrietta Dumas")],
    ["Sal Dali": (41, false, "Gala Dali")],
    ["Joe Kavalier": (39, false, "Sam and Elaine Kavalier")],
    ["Ben Finkelstein": (44, false, "Aaron and Jill Finkelstein")],
    ["Diego Soto": (41, true, "Robin and Sarika Soto")],
    ["Chloe Alaska": (47, false, "David and Jamie Alaska")],
    ["Arnold Willis": (43, false, "Claire Willis")],
    ["Phillip Helm": (44, true, "Thomas Helm and Eva Jones")],
    ["Les Clay": (42, true, "Wynonna Brown")],
    ["Herschel Krustofski": (45, true, "Hyman and Rachel Krustofski")]
]


//for i in 0..<players.count {
//    let name = players[i].keys.first!
//    let info = players[i].values.first!
//    print("\(name): \(info)")
//}

//  Create appropriate variables and logic to sort and store players into three teams: Sharks, Dragons and Raptors.
//  Be sure that your logic results in all teams having the same number of experienced players on each.

//  Provide logic that prints a personalized letter to the guardians specifying: the player’s name, guardians' names, team name, and date/time of their first team practice.
//  The letters should be visible when code is placed in a XCode Playground or run in an XCode project.

//  As always, please add concise and descriptive comments to your code and be sure to name your constants, variables and keys descriptively.

//  Also, if you would like to attain an “exceeds expectations” rating for this project, add logic to ensure that each teams’ average height is within 1.5 inches of the others.
//  (Please note, this feature only needs to meet the 1.5inch threshold for this set of players, not for all potential future sets of players.)



func countExperienced (team: [[String: (height: Int, experience: Bool, guardians: String)]]) -> Int {
    var count = 0
    for i in 0..<team.count {
        let info = team[i].values.first!
        if (info.experience) {
            count += 1
        }
    }
    return count
}

func calcAverageHeight (team: [[String: (height: Int, experience: Bool, guardians: String)]]) -> Double {
    var sumHeight = 0
    for i in 0..<team.count {
        let info = team[i].values.first!
        sumHeight += info.height
    }
    return Double(sumHeight)/Double(team.count)
}

let averageHeight = calcAverageHeight(team: players)


// 1. We have to sort arrays by Experience and Height
// to apply Experience (Bool) to Int, lets true = 50, false = 0, since experience is more needed than height

// find index of max value (experience+height) in array
func findMaxUseful(array: [[String: (height: Int, experience: Bool, guardians: String)]]) -> Int {
    if (array.isEmpty) {
        return -1
    }
    var indexMax = 0
    var max = 0
    var useful = 0
    for i in 0..<array.count {
        let info = array[i].values.first!
        if (info.experience) {
            useful = 50 + info.height
        } else {
            useful = info.height
        }
            
        if useful > max {
            max = useful
            indexMax = i
        }
    }
    return indexMax
}

// 2. We will pick one player to each team from top by this order
// orderOfAppend - array of int, where each element mean number of team in which we will pick up best player on each step of iteration
// for example [0, 1, 2] mean we will append best players in: 1. team #0, 2. team #1 3. team #2 4. team #0 and so on,
// which is not too fair, because all best players on each iteration will be in team #0, second best - in team #1, and third best - in team #2
// so more fair order looks like [0, 1, 2, 1, 2, 0, 2, 0, 1, 0, 2, 1, 2, 1, 0, 1, 0, 2]
// (and for this starting array of players is best available order of appending, which allow us select teams 
// where difference between average height is minimal, with same numbers of experienced players offcourse)
func spreadPlayers (orderOfAppend: [Int], playersArray: [[String: (height: Int, experience: Bool, guardians: String)]]) ->
    ([[String: (height: Int, experience: Bool, guardians: String)]],
    [[String: (height: Int, experience: Bool, guardians: String)]],
    [[String: (height: Int, experience: Bool, guardians: String)]]) {
    var players = playersArray
    let team : [[String: (height: Int, experience: Bool, guardians: String)]] = []
    var teams = [team, team, team]
    var count = 0
    while !players.isEmpty {
        let currentBestPlayerIndex = findMaxUseful(array: players)
        let currentAppendTeam = orderOfAppend[count]
        teams[currentAppendTeam].append(players[currentBestPlayerIndex])
        players.remove(at: currentBestPlayerIndex)
        count += 1
        if (count == orderOfAppend.count) {
            count = 0
        }
    }
    return (teams[0], teams[1], teams[2])
}

func printReportAboutSpread (orderOfAppend: [Int], playersArray: [[String: (height: Int, experience: Bool, guardians: String)]]) {
    let spreaded = spreadPlayers(orderOfAppend: orderOfAppend, playersArray: players)
    
    let teamSharks = spreaded.0
    let teamDragons = spreaded.1
    let teamRaptors = spreaded.2
    
    let averageHeightSharks = calcAverageHeight(team: teamSharks)
    let averageHeightDragons = calcAverageHeight(team: teamDragons)
    let averageHeightRaptors = calcAverageHeight(team: teamRaptors)
    let sumDifferences = abs(averageHeightDragons-averageHeightSharks)+abs(averageHeightRaptors-averageHeightDragons)+abs(averageHeightSharks-averageHeightRaptors)
    
    print("Order of appending players is: \(orderOfAppend)")
    print("Average height of all players is: \(averageHeight)")
    print("Average height of Sharks team is: \(calcAverageHeight(team: teamSharks))")
    print("Average height of Dragons team is: \(calcAverageHeight(team: teamDragons))")
    print("Average height of Raptors team is: \(calcAverageHeight(team: teamRaptors))")
    print("The summ of differences of average heights of teams is: \(sumDifferences)")
    print(" ")
}

var orderOfAppend = [0,1,2,2,1,0] // in which order best players will be spread between teams
printReportAboutSpread(orderOfAppend: orderOfAppend, playersArray: players)

orderOfAppend = [0,1,2,1,2,0] // in which order best players will be spread between teams
printReportAboutSpread(orderOfAppend: orderOfAppend, playersArray: players)

orderOfAppend = [0,1,2,1,2,0,2,0,1,0,2,1,2,1,0,1,0,2] // in which order best players will be spread between teams
printReportAboutSpread(orderOfAppend: orderOfAppend, playersArray: players)

orderOfAppend = [0,1,2,1,2,0,2,0,1,0,2,1,2,1,0,1,0,2,0,1,2,1,2,0] // in which order best players will be spread between teams
printReportAboutSpread(orderOfAppend: orderOfAppend, playersArray: players)


orderOfAppend = [0,1,2,1,2,0,2,0,1,2,0,1] // in which order best players will be spread between teams
printReportAboutSpread(orderOfAppend: orderOfAppend, playersArray: players)

func writeLetter (teamName: String, playerName: String, guardians: String, dateFirstTraining: String) -> String {
    return "Dear \(guardians), your ward \(playerName) was selected to hockey team \(teamName). First training will have place \(dateFirstTraining)."
}

let spreaded = spreadPlayers(orderOfAppend: orderOfAppend, playersArray: players)
let namesOfTeams = ["Sharks", "Dragons", "Raptors"]

for i in 0..<namesOfTeams.count {
    var team : [[String: (height: Int, experience: Bool, guardians: String)]] = []
    let teamName = namesOfTeams[i]
    print("")
    print("Letters of \(teamName) team:")
    switch (i) {
        case 0: team = spreaded.0
        break
        case 1: team = spreaded.1
        break
        case 2: team = spreaded.2
        break;
    default: team = []
    }
    for j in 0..<team.count {
        let name = team[j].keys.first!
        let info = team[j].values.first!
        print("\(j+1). " + writeLetter(teamName: namesOfTeams[i], playerName: name, guardians: info.guardians, dateFirstTraining: "12/10/2016"))
    }
}
