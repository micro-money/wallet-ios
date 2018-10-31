//
//  CurrencyChartView.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 21.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit
import SwiftChart

class CurrencyChartView: UIView {

    var currencyArray : [String] = []

    let currencyRateModels: [CurrencyRateModel] = []

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self

            collectionView.register(R.nib.currencyChartCollectionViewCell)

            //if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                //flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
            //}
        }
    }

    var chart1: Chart!
    var chart2: Chart!

    var selectedIndex = 0
    
    var yOffset: CGFloat = 30
    var topOffset: CGFloat = 0

    func applyData(currency: String?) {

        if currency == nil {
            currencyArray = ["BTC", "ETH"]
            configureChart(currency: currencyArray.first!)
        } else {
            currencyArray = []
            configureChart(currency: currency!)
        }
    }

    func configureChart(currency: String) {

        if chart1 != nil {
            chart1.removeAllSeries()
            chart1.removeFromSuperview()
            chart1 = nil
        }

        if chart2 != nil {
            chart2.removeAllSeries()
            chart2.removeFromSuperview()
            chart2 = nil
        }

        let currencyRateModels = StorageManager.shared.getCurrencyRateLast7Days(currency: currency)!

        if currencyRateModels.count == 0 {
            currencyArray = []
            return
        }

        let numPeak = 14
        let deltaPeak = currencyRateModels.count/numPeak-1

        var currencyRatePeaks: [CurrencyRateModel] = []
        if deltaPeak <= 0 {
            for currencyRate in currencyRateModels {
                currencyRatePeaks.append(currencyRate)
            }
        } else {
            for index in 0...numPeak {
                currencyRatePeaks.append(currencyRateModels[(currencyRateModels.count-1)-deltaPeak*index])
            }
        }

        var min: Double = Double.greatestFiniteMagnitude
        var max: Double = 0
        for currencyRateModel in currencyRatePeaks {
            if currencyRateModel.USD < min {
                min = currencyRateModel.USD
            }
            if currencyRateModel.USD > max {
                max = currencyRateModel.USD
            }
        }
        var k = max - min
        if k == 0 {
            k = 1
        }
        var dataAll:[Double] = []
        for currencyRateModel in currencyRatePeaks {
            let d = currencyRateModel.USD - min
            dataAll.append(d/k)
        }
        var data:[Double] = []
        for dataA in dataAll {
            data.append(dataA*Double(self.backView.bounds.height-yOffset)+Double(yOffset))
        }

        chart1 = Chart(frame: CGRect(x: 0, y: 0, width: self.backView.bounds.width, height: self.backView.bounds.height))
        chart1.showXLabelsAndGrid = false
        chart1.showYLabelsAndGrid = false
        chart1.bottomInset = 0
        chart1.topInset = topOffset
        chart1.gridColor = UIColor.clear
        chart1.axesColor = UIColor.clear
        chart1.areaAlphaComponent = 0.2 //0.12

        let series1 = ChartSeries(data)
        series1.color = Color(hexString: "33000000")
        series1.area = true
        chart1.add(series1)
        chart1.alpha = 0.2
        chart1.minY = 0

        backView.addSubview(chart1)
        chart1.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(backView)
        }

        chart2 = Chart(frame: CGRect(x: 0, y: 0, width: self.backView.bounds.width, height: self.backView.bounds.height))
        chart2.showXLabelsAndGrid = false
        chart2.showYLabelsAndGrid = false
        chart2.bottomInset = 0
        chart2.topInset = topOffset
        chart2.gridColor = UIColor.clear
        chart2.axesColor = UIColor.clear

        let series2 = ChartSeries(data)
        series2.color = Color(hexString: "99ffffff")
        chart2.add(series2)
        chart2.alpha = 0.4
        chart2.minY = 0

        backView.addSubview(chart2)
        chart2.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(backView)
        }

        collectionView.reloadData()
    }
}

extension CurrencyChartView : UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return currencyArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.currencyChartCollectionViewCell, for: indexPath)!

        let currency = currencyArray[indexPath.row]
        if let rate = StorageManager.shared.getCurrencyRateLast7Days(currency: currency)?.last {
            cell.currencyLabel.text = currency.uppercased()
            cell.dataLabel.text = "\(rate.USD.cleanValue)"
        }

        cell.isSelectCell = selectedIndex == indexPath.row

        return cell
    }
}

extension CurrencyChartView : UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currency = currencyArray[indexPath.row]
        selectedIndex = indexPath.row
        configureChart(currency: currency)
    }
}
