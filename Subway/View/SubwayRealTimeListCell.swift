//
//  SubwayRealTimeListCell.swift
//  Subway
//
//  Created by WalterCho on 2022/11/25.
//

import UIKit
import SnapKit

class SubwayRealTimeListCell: UICollectionViewCell {
    
    private lazy var lineLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: .bold)
        label.text = "지하철 역명"
        
        return label
    }()
    
    private lazy var remainTimeLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: .bold)
        label.text = "도착정보"
        
        return label
    }()
    
    func setUpViews(data: StationArrivalDataResponse.RealTimeArrival) {
        setUpSubViews(data: data)
        
        //Shadow의 경우 기준값이 되는 배경색이 반드시 필요함
        self.layer.cornerRadius = 12.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 10
        backgroundColor = .systemBackground     //Shadow적용시 필수 지정
    }
}

private extension SubwayRealTimeListCell {
    func setUpSubViews(data: StationArrivalDataResponse.RealTimeArrival) {
        [lineLable, remainTimeLable].forEach { view in
            addSubview(view)
        }
        
        lineLable.snp.makeConstraints { view in
            view.leading.equalToSuperview().inset(16.0)
            view.top.equalToSuperview().inset(16.0)
        }
        
        remainTimeLable.snp.makeConstraints { view in
            view.leading.equalTo(lineLable)
            view.top.equalTo(lineLable.snp.bottom).offset(16.0)
            view.bottom.equalToSuperview().inset(16.0)
        }
        
        lineLable.text = data.line
        remainTimeLable.text = data.remainTime
    }
}
