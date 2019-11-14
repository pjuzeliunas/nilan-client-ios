//
//  FanSpeedCell.swift
//  Nilan
//
//  Created by Povilas Juzeliunas on 13/11/2019.
//  Copyright © 2019 Povilas Juzeliunas. All rights reserved.
//

import UIKit

protocol SegmentedControlCellDelegate {
    func didSelectSegment(sender: Any, atIndex: Int)
}

class SegmentedControlCell<ViewModel: SegmentedControl>: UITableViewCell {
    var delegate: SegmentedControlCellDelegate?
    
    let segmentedControl = UISegmentedControl(items: ViewModel.segments)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.textLabel?.text = ViewModel.title
        
        contentView.addSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(SegmentedControlCell.valueDidChange(sender:)), for: .valueChanged)
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
        delegate?.didSelectSegment(sender: self, atIndex: segmentedControl.selectedSegmentIndex)
    }
    
}
