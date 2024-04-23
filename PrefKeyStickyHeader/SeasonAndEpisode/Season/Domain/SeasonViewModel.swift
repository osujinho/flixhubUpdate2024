//
//  SeasonViewModel.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/19/24.
//

import Foundation

@MainActor
class SeasonViewModel: ObservableObject {
    
    @Published private(set) var seasonDetail: SeasonDetailResponse?
    @Published private(set) var errorMessage: String = ""
    @Published var hasError: Bool = false
    @Published private(set) var isLoading: Bool = false
    
    @Published var seasonPickerOption: SeasonPickerOption? = .about
    
    // For Trailer
    @Published var playTrailer: Bool = false
    @Published var showNoTrailerAlert: Bool = false
    
    let alertTitle: String = "Error Loading Season Details"
    var service: SeasonAndEpisodeServiceable
    
    var trailerKey: String {
        if let video = seasonDetail?.videos?.first(where: {
            $0.type?.lowercased() == "trailer"
        }) {
            return video.key
        }
        return ""
    }
    
    init(service: SeasonAndEpisodeServiceable, seriesId: Int, seasonNumber: Int) {
        self.service = service
        
        Task {
            self.seasonDetail = await fetchSeasonDetail(seriesId: seriesId, seasonNumber: seasonNumber)
        }
    }
    
    // MARK: - Methods that can be called outside viewModel
    
    func fetchSeasonDetail(seriesId: Int, seasonNumber: Int) async -> SeasonDetailResponse? {
        
        guard !isLoading else { return nil }
        self.isLoading = true
        self.hasError = false
        self.errorMessage = ""
        
        do {
            let response: SeasonDetailResponse = try await service.getSeasonDetail(seriesId: seriesId, seasonNumber: seasonNumber)
            self.isLoading = false
            return response
            
        } catch {
            self.errorMessage = RequestError.getMessage(error: error)
            self.isLoading = false
            self.hasError = true
            return nil
        }
    }
    
    func checkForTrailer() {
        if !trailerKey.isEmpty {
            self.playTrailer = true
        } else {
            showNoTrailerAlert.toggle()
        }
    }
}
