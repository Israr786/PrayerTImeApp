//
//  ViewController.swift
//  isk
//
//  Created by Apple on 6/29/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

let cellId = "cellId"

class ViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout   {

    let prayerNameList = ["Fajr","Sunrise","Zuhr","Asr","Magrib","Isha"]
    var prayerTimeList = [String]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "Prayer table"
        collectionView?.backgroundColor = UIColor.white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.alwaysBounceVertical = true
        
      
        
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let date = cal.dateComponents([.year, .month, .day], from: Date())
        
        let coordinates = Coordinates(latitude:  37.548271, longitude: -121.988571)
        var params = CalculationMethod.moonsightingCommittee.params
        params.madhab = .hanafi
        
        if let prayers = PrayerTimes(coordinates: coordinates, date: date, calculationParameters: params) {
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
      //      formatter.timeZone = TimeZone(identifier: "America/New_York")!
            formatter.timeZone = TimeZone(identifier: "America/Los_Angeles")!
             prayerTimeList.append(formatter.string(from: prayers.fajr))
             prayerTimeList.append(formatter.string(from: prayers.sunrise))
             prayerTimeList.append(formatter.string(from: prayers.dhuhr))
             prayerTimeList.append(formatter.string(from: prayers.asr))
             prayerTimeList.append(formatter.string(from: prayers.maghrib))
             prayerTimeList.append(formatter.string(from: prayers.isha))
        }
        
        collectionView?.register(TimeCell.self, forCellWithReuseIdentifier: cellId)
     
      
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 44.0)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let date = cal.dateComponents([.year, .month, .day], from: Date())
        
        let coordinates = Coordinates(latitude:  37.548271, longitude: -121.988571)
        var params = CalculationMethod.moonsightingCommittee.params
        params.madhab = .hanafi
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TimeCell
       
        
        if let prayers = PrayerTimes(coordinates: coordinates, date: date, calculationParameters: params) {
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            //      formatter.timeZone = TimeZone(identifier: "America/New_York")!
            formatter.timeZone = TimeZone(identifier: "America/Los_Angeles")!
            NSLog("fajr %@", formatter.string(from: prayers.fajr))
        
        cell.prayerNameLabel.text = prayerNameList[indexPath.row]
        cell.prayerTimeLabel.text = prayerTimeList[indexPath.row]
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 90.0)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    
}


class TimeCell : UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(displayP3Red: 0/255, green: 120/255, blue: 50/255, alpha: 1)
        
        setupViews()
    }

    
    
    let prayerNameLabel : UILabel = {
        let label = UILabel()
        label.text = "Zhur"
        label.font = UIFont.boldSystemFont(ofSize: 21.0)
        label.textColor = UIColor.white
        return label
        
    }()
    
    let prayerTimeLabel : UILabel = {
        let label = UILabel()
        label.text = "1:18 PM"
        label.font = UIFont.boldSystemFont(ofSize: 21.0)
        label.textColor = UIColor.white
        return label
        
    }()
   
    func setupViews() {
        print("insdie cell view")
        addSubview(prayerNameLabel)
        addSubview(prayerTimeLabel)
     
        addConstraintWithFormat(format:"H:|-35-[v0][v1]-150-|", views:prayerNameLabel,prayerTimeLabel)
        addConstraintWithFormat(format:"V:|-20-[v0(44)]|", views: prayerTimeLabel)
        addConstraintWithFormat(format:"V:|-20-[v0(44)]|", views: prayerNameLabel)
        
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let date = cal.dateComponents([.year, .month, .day], from: Date())
        
        let coordinates = Coordinates(latitude:  37.548271, longitude: -121.988571)
        var params = CalculationMethod.moonsightingCommittee.params
        params.madhab = .hanafi
        
        if let prayers = PrayerTimes(coordinates: coordinates, date: date, calculationParameters: params) {
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            //      formatter.timeZone = TimeZone(identifier: "America/New_York")!
            formatter.timeZone = TimeZone(identifier: "America/Los_Angeles")!
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    
    func addConstraintWithFormat(format:String,views:UIView...) {
        var viewsDictionary = [String : UIView]()
        for(index,view) in views.enumerated(){
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
}
}
