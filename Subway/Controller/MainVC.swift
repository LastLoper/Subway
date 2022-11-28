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
        
        getHolidayData()
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
            .responseDecodable(of: StationResponse.self) { response in
//                guard case .success(let data) = response.result else { return }
                switch response.result {
                case .success(let data):
                    print(data)

                    self.stations = data.stations
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error : \(error.localizedDescription)")
                }
            }
            .resume()
    }
    
    //URLSession을 이용한 공휴일 데이터 가져오기
    private func getHolidayData() {
        let urlHoliday = "https://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/getRestDeInfo?solYear=2022&solMonth=03&ServiceKey=IIL7UWdyZVoWG7cxSTS8dR7GOOF39dZfa5Yb2ycPnkfuzythdYSJAHrD3ymecrT0Ll0p1B9F%2Bc3diiWELt3nUw%3D%3D&_type=json"
        if let url = URL(string: urlHoliday) {
            let request = URLRequest.init(url: url)
            
            URLSession.shared.dataTask(with: request) {
                (data, response, error) in guard let data = data else {return}
                let decoder = JSONDecoder()
                print(response as Any)
                do{
                    let json = try decoder.decode(HolidayResponse.self , from: data)
                    print(json)
                }
                catch{
//                    print(error)
                }
            }.resume()
        }
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
