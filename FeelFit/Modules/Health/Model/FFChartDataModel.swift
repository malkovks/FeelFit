//
//  FFChartDataModel.swift
//  FeelFit
//
//  Created by Константин Малков on 23.04.2024.
//

import CareKit

struct ChartData {
    let series: [OCKDataSeries]
    let headerViewTitleLabel: String
    let headerViewDetailLabel: String
    let graphViewAxisMarkers: [String]
}
