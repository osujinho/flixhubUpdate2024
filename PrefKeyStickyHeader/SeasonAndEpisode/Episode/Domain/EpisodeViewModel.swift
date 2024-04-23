//
//  EpisodeViewModel.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/19/24.
//

import Foundation
import Combine

@MainActor
class EpisodeViewModel: ObservableObject {
    
    @Published private(set) var episodeDetail: EpisodeDetailResponse?
    @Published var hasError: Bool = false
    @Published private(set) var errorMessage: String = ""
    @Published private(set) var isLoading: Bool = false
    
    // For Pickers
    @Published var episodePickerOption: EpisodePickerOption? = .about
    @Published var currentEpisodeNumber: EpisodeMenuData?
    private var cancellables = Set<AnyCancellable>()
    
    var totalEpisodes: Int
    var seriesId: Int
    var seasonNumber: Int
    
    var episodes: [EpisodeMenuData] {
        return Array(1...totalEpisodes).map { .init(episodeNumber: $0) }
    }
    
    // For Trailer
    @Published var playTrailer: Bool = false
    @Published var showNoTrailerAlert: Bool = false
    
    let alertTitle: String = "Error Loading Episode Details"
    var service: SeasonAndEpisodeServiceable
    
    var trailerKey: String {
        if let video = episodeDetail?.videos?.first(where: {
            $0.type?.lowercased() == "trailer"
        }) {
            return video.key
        }
        return ""
    }
    
    init(service: SeasonAndEpisodeServiceable, seriesId: Int, seasonNumber: Int, episodeNumber: Int, totalEpisodes: Int?) {
        
        self.service = service
        self.currentEpisodeNumber = .init(episodeNumber: episodeNumber)
        self.totalEpisodes = totalEpisodes ?? episodeNumber
        self.seriesId = seriesId
        self.seasonNumber = seasonNumber
        
        $currentEpisodeNumber
            .dropFirst() // Skip initial value
            .sink { [weak self] episode in
                guard let self = self, let episode = episode else { return }
                Task {
                    self.episodeDetail = await self.fetchEpisodeDetail(seriesId: seriesId, seasonNumber: seasonNumber, episodeNumber: episode.episodeNumber)
                }
            }
            .store(in: &cancellables)
        
        Task {
            self.episodeDetail = await fetchEpisodeDetail(seriesId: seriesId, seasonNumber: seasonNumber, episodeNumber: episodeNumber)
        }
    }
    
    // MARK: - Methods that can be called outside viewModel
    
    func fetchEpisodeDetail(seriesId: Int, seasonNumber: Int, episodeNumber: Int) async -> EpisodeDetailResponse? {
        
        guard !isLoading else { return nil }
        self.isLoading = true
        self.hasError = false
        self.errorMessage = ""
        
        do {
            let response: EpisodeDetailResponse = try await service.getEpisodeDetail(seriesId: seriesId, seasonNumber: seasonNumber, episodeNumber: episodeNumber)
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
