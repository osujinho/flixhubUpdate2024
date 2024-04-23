//
//  MenuPickerDemo.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/12/24.
//

import SwiftUI

struct MenuPickerDemo: View {
    
    @State var selection: SortCriteriaOption? = .popularityDesc
    @State var movieGenre: Set<MovieGenre>? = []
    @State var seriesGenre: Set<SeriesGenre>? = []
    @State private var selectedYear: Int = YearData.currentYear
    @State var selectedYearData: YearData? = .year(YearData.currentYear)
    
    var body: some View {
        ZStack {
            AppAssets.backgroundColor
                .ignoresSafeArea()
            
            VStack {
                VerticalLabelContainerBuilder(header: "Sort by", content: {
                    PickerMenuBuilder(selection: .single(binding: $selection), options: SortCriteriaOption.allCases)
                })
                
                Spacer()
                VerticalLabelContainerBuilder(header: "Movie Genre", content: {
                    PickerMenuBuilder(selection: .multiple(binding: $movieGenre), options: MovieGenre.allCases)
                })
                
                Spacer()
                VerticalLabelContainerBuilder(header: "Series Genre", content: {
                    PickerMenuBuilder(selection: .multiple(binding: $seriesGenre), options: SeriesGenre.allCases)
                })
                
                Spacer()
                VerticalLabelContainerBuilder(header: "Release Year", content: {
                    PickerMenuBuilder(selection: .single(binding: $selectedYearData), options: YearData.allYears)
                })
            }
            .padding()
        }
    }
}

#Preview {
    MenuPickerDemo()
}
