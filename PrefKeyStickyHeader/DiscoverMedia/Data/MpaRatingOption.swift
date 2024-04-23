//
//  MpaRatingOption.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/21/24.
//

import Foundation

enum MpaRatingOption: EnumPickable {
    case nr, g, pg, pg13, r, nc17
    
    var id: MpaRatingOption { self }
    
    var description: String {
        switch self {
        case .nr: return "NR"
        
        case .g: return "G"
        
        case .pg: return "PG"
        
        case .pg13: return "PG-13"
        
        case .r: return "R"
        
        case .nc17: return "NC-17"
        }
    }
    
    var meaning: String {
        switch self {
        case .nr: return "No rating information."
        
        case .g: return "All ages admitted. There is no content that would be objectionable to most parents. This is one of only two ratings dating back to 1968 that still exists today."
        
        case .pg: return "Some material may not be suitable for children under 10. These films may contain some mild language, crude/suggestive humor, scary moments and/or violence. No drug content is present. There are a few exceptions to this rule. A few racial insults may also be heard."
        
        case .pg13: return "Some material may be inappropriate for children under 13. Films given this rating may contain sexual content, brief or partial nudity, some strong language and innuendo, humor, mature themes, political themes, terror and/or intense action violence. However, bloodshed is rarely present. This is the minimum rating at which drug content is present."
        
        case .r: return "Under 17 requires accompanying parent or adult guardian 21 or older. The parent/guardian is required to stay with the child under 17 through the entire movie, even if the parent gives the child/teenager permission to see the film alone. These films may contain strong profanity, graphic sexuality, nudity, strong violence, horror, gore, and strong drug use. A movie rated R for profanity often has more severe or frequent language than the PG-13 rating would permit. An R-rated movie may have more blood, gore, drug use, nudity, or graphic sexuality than a PG-13 movie would admit."
        
        case .nc17: return "These films contain excessive graphic violence, intense or explicit sex, depraved, abhorrent behavior, explicit drug abuse, strong language, explicit nudity, or any other elements which, at present, most parents would consider too strong and therefore off-limits for viewing by their children and teens. NC-17 does not necessarily mean obscene or pornographic in the oft-accepted or legal meaning of those words."
        }
    }
}
