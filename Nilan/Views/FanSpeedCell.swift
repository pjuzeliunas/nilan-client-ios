//
//  FanSpeedCell.swift
//  Nilan
//
//  Created by Povilas Juzeliunas on 13/11/2019.
//  Copyright © 2019 Povilas Juzeliunas. All rights reserved.
//

import UIKit

protocol FanSpeedCellDelegate {
    func didSelectSpeed(atIndex: Int)
}

class FanSpeedCell: UITableViewCell {
    
    var delegate: FanSpeedCellDelegate?
    
    let segmentedControl = UISegmentedControl(items: ["I", "II", "III", "IV"])
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.textLabel?.text = "Fan Speed"
        
        contentView.addSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(FanSpeedCell.valueDidChange(sender:)), for: .valueChanged)
        segmentedControl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16.0)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().offset(-16.0)
            make.width.equalTo(200.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func valueDidChange(sender: UISegmentedControl) {
        delegate?.didSelectSpeed(atIndex: segmentedControl.selectedSegmentIndex)
    }
    
}

extension FanSpeed {
    func toSegmentedControlIndex() -> Int {
        return rawValue - 101
    }
}
