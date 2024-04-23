//
//  FilterFormView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/10/24.
//

import SwiftUI

struct FilterFormView: View {
    
    @StateObject var viewModel: DiscoverViewModel
    
    private let formListBg: Color = AppAssets.formListBg
    private let bgColor: Color = AppAssets.backgroundColor
    
    init() {
        self._viewModel = StateObject(wrappedValue: DiscoverViewModel(service: DiscoveryService()) )
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                bgColor.ignoresSafeArea(edges: .all)
                
                VStack {
                    
                    CustomPickerView(selection: $viewModel.mediaOption, screenWidth: geometry.size.width, forSearchScope: true)

                    Form {
                        Section {
                            HStack {
                                Text("Sort by")
                                
                                Spacer().frame(width: 20)
                                
                                PickerMenuBuilder(selection: .single(binding: $viewModel.sortCriteria), options: SortCriteriaOption.allCases)
                            }
                        }
                        .listRowBackground(formListBg)
                        
                        if viewModel.mediaOption == .movie {
                            Section {
                                HStack {
                                    Text("Certification")
                                    
                                    Spacer().frame(width: 20)
                                    
                                    PickerMenuBuilder(selection: .single(binding: $viewModel.certification), options: MpaRatingOption.allCases)
                                }
                            }
                            .listRowBackground(formListBg)
                            .animation(.easeInOut, value: viewModel.mediaOption)
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            
//                            if let genreConfig = viewModel.seriesGenreConfiguration {
//                                CustomPickerView(
//                                    selection: $genreConfig.andOrOption,
//                                    screenWidth: UIScreen.main.bounds.width
//                                )
//                            }
                            
                            //PickerMenuBuilder(selection: .multiple(binding: $viewModel.seriesGenreSet), options: SeriesGenre.allCases)
                        }
                        
                    }
                    .font(.system(size: 15))
                    .scrollContentBackground(.hidden)
                }
            }
        }
    }
}

#Preview {
    FilterFormView()
}
