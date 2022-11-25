//
//  SubwayRealTimeVC.swift
//  Subway
//
//  Created by WalterCho on 2022/11/25.
//

import UIKit
import SnapKit
import Alamofire

private let reuseIdentifier = "SubwayRealTimeListCell"

class SubwayRealTimeVC: UIViewController {
    private let station: Station
    private var realTimeStateOfSubway: [StationArrivalDataResponse.RealTimeArrival] = []
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        
        return refreshControl
    }()
    
    @objc
    private func fetchData() {
        //새로고침할 때 데이터를 새로 불러온다.
        
        let stationName = station.stationName
        let urlString = "http://swopenapi.seoul.go.kr/api/subway/sample/json/realtimeStationArrival/0/5/\(stationName.replacingOccurrences(of: "역", with: ""))"
        
        AF.request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .responseDecodable(of: StationArrivalDataResponse.self) { [weak self] response in
                guard let self = self else { return }
                self.refreshControl.endRefreshing()
                
                guard case .success(let data) = response.result else { return }
                self.realTimeStateOfSubway = data.realtimeArrivalList
                self.collectionView.reloadData()
            }
            .resume()
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        //CollectionView의 최소 사이즈(estimated)
        let width = view.frame.width - 32.0
        let height = 100.0
        layout.estimatedItemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SubwayRealTimeListCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.refreshControl = refreshControl
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    init(station: Station) {
        self.station = station
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        navigationItem.title = "지역명"
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { view in
            view.edges.equalToSuperview()
        }
        
        fetchData()
    }
}
// MARK: UICollectionViewDataSource
extension SubwayRealTimeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return realTimeStateOfSubway.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SubwayRealTimeListCell
        
        let stateOfSubway = realTimeStateOfSubway[indexPath.item]
        cell.setUpViews(data: stateOfSubway)
        
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension SubwayRealTimeVC: UICollectionViewDelegate {
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
}
