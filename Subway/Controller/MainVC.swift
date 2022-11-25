//
//  MainVC.swift
//  Subway
//
//  Created by WalterCho on 2022/11/25.
//

import UIKit
import SnapKit
import Alamofire

class MainVC: UIViewController {
    private var stations: [Station] = []
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "지하철 역을 입려해주세요"
        
        //searchBar가 활성화 되었을 때 아래쪽 빈공간을 어둡게 하는, 음영을 줄 것인지 지정하는 옵션
        searchController.obscuresBackgroundDuringPresentation = false
        
        //특정 동작이 트리거되었을 때 처리
        searchController.searchBar.delegate = self
        
        return searchController
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationItems()
        setUpTableViewLayout()
    }
    
    private func setUpNavigationItems() {
        navigationController?.navigationBar.prefersLargeTitles = true       //큰 제목 사용
        navigationItem.searchController = searchController
        navigationItem.title = "지하철 도착 정보"
        
    }
    
    private func setUpTableViewLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { view in
            view.edges.equalToSuperview()
        }
    }
    
    private func requestStationName(stationName: String) {
        let urlString = "http://openapi.seoul.go.kr:8088/sample/json/SearchInfoBySubwayNameService/1/5/\(stationName)"
        
        /*
         한글이 깨지지 않고 서버까지 전달되도록 해주는 옵션
         addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
         */
        AF.request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .responseDecodable(of: StationResponse.self) { reponse in
//                guard case .success(let data) = response.result else { return }
                switch reponse.result {
                case .success(let data):
                    print(data.stations)
                    
                    self.stations = data.stations
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error : \(error.localizedDescription)")
                }
            }
            .resume()
    }
}

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let station = stations[indexPath.item]
        cell.textLabel?.text = station.stationName
        cell.detailTextLabel?.text = station.lineNumber
        
        return cell
    }
}

extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let station = stations[indexPath.item]
        let realTimeVC = SubwayRealTimeVC(station: station)
        self.navigationController?.pushViewController(realTimeVC, animated: true)
    }
}

extension MainVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //searchBar의 작성이 시작될 때
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //searchBar의 작성이 끝날 때
        stations = []
        tableView.isHidden = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //글자가 바뀌는 것을 감지하는 메서드
        requestStationName(stationName: searchText)
    }
}
