//
//  ImageLoader.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/7/24.
//

import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    
    @Published private(set) var image: UIImage?
    @Published private(set) var isLoading: Bool = false
    private let path: String
    private var cancellable: AnyCancellable?
    private var cache: CashableImage?
    private static let imageProcessingQueue = DispatchQueue(label: "image-processing")
    private let imageBaseUrl: String = "https://image.tmdb.org/t/p/w500"
    private let youtubeBaseUrl: String = "https://i.ytimg.com/vi/#path#/maxresdefault.jpg"
    
    init(path: String?, cache: CashableImage? = nil) {
        
        self.path = path ?? ""
        self.cache = cache
    }

    deinit {
        cancel()
    }
    
    func load() {
        
        guard !isLoading else { return }
        
        if let image = cache?[path] {
            self.image = image
            self.onFinish()
            return
        } else if isLocal {
            self.image = UIImage(named: path)
            self.onFinish()
            return
        }
        
        guard let url = url else {
            self.onFinish()
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: Self.imageProcessingQueue)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(
                receiveSubscription: { [weak self] _ in self?.onStart() },
                receiveOutput: { [weak self] in self?.cache($0) },
                receiveCompletion: { [weak self] _ in self?.onFinish() },
                receiveCancel: { [weak self] in self?.onFinish() }
            )
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.image = $0
            }
    }

    func cancel() {
        cancellable?.cancel()
    }
    
    // MARK: - Handle isLoading
    
    private func onStart() {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = true
        }
    }
    
    private func onFinish() {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = false
        }
    }
    
    // MARK: - Cache
    
    private func cache(_ image: UIImage?) {
        //image.map { cache?[path] = $0 }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            image.map { self.cache?[self.path] = $0 }
        }
    }
    
    // MARK: - Prepare URL
    
    private var url: URL? {
        var urlString: String
        
        if isLink {
            urlString = path
        } else if isYoutube {
            urlString =  youtubeBaseUrl.replacingOccurrences(of: "#path#", with: path)
        } else {
            urlString = imageBaseUrl.appending(path)
        }
        
        return URL(string: urlString)
    }
    
    fileprivate var isLink: Bool {
        let types: NSTextCheckingResult.CheckingType = [.link]
        let detector = try? NSDataDetector(types: types.rawValue)
        guard (detector != nil && path.count > 0) else { return false }
        if detector!.numberOfMatches(in: path, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, path.count)) > 0 {
            return true
        }
        return false
    }
    
    fileprivate var isYoutube: Bool {
        let youtubeIdRegex = #"^[a-zA-Z0-9_-]{11}$"#
        let idPredicate = NSPredicate(format:"SELF MATCHES %@", youtubeIdRegex)
        return idPredicate.evaluate(with: path)
    }
    
    fileprivate var isLocal: Bool {
        if let _ = UIImage(named: path) {
            return true
        } else {
            return false
        }
    }
}
