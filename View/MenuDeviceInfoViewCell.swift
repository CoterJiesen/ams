//
//  RecordsCell.swift
//  ams
//
//  Created by yangyuan on 2017/6/15.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

//
//  HomeTableViewRecordsCell.swift
//  ams
//
//  Created by coterjiesen on 2017/5/19.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit

class DeviceTotalView: UIView{
    let leftView = UIView()
    let rightView = UIView()
    let titleTotalDev: UILabel = {
        let lable = UILabel()
        lable.text = "设备数量："
        lable.font = v2Font(16)
        return lable
    }()
    let valueTotalDev: UILabel = {
        let lable = UILabel()
        lable.text = "0"
        lable.font = v2Font(15)
        return lable
    }()
    let titleAvailableDev: UILabel = {
        let lable = UILabel()
        lable.text = "可用设备："
        lable.font = v2Font(16)
        return lable
    }()
    let valueAvailableDev: UILabel = {
        let lable = UILabel()
        lable.text = "0"
        lable.font = v2Font(15)
        return lable
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        leftView.layer.cornerRadius = 10
        rightView.layer.cornerRadius = 10
        leftView.layer.borderWidth = 1
        leftView.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor;
        rightView.layer.borderWidth = 1
        rightView.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor;
        
        leftView.backgroundColor = .clear
        rightView.backgroundColor = .clear
        
        self.addSubview(leftView)
        self.addSubview(rightView)
        leftView.addSubview(titleTotalDev)
        leftView.addSubview(valueTotalDev)
        rightView.addSubview(titleAvailableDev)
        rightView.addSubview(valueAvailableDev)
        
        self.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(self)
        }
        self.leftView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(3)
            make.bottom.equalTo(self).offset(-3)
            make.width.equalTo(SCREEN_WIDTH / 2 - 8)
            make.centerX.equalTo(self).offset(3 - SCREEN_WIDTH / 4)
        }
        self.rightView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(3)
            make.bottom.equalTo(self).offset(-3)
            make.width.equalTo(SCREEN_WIDTH / 2 - 8)
            make.centerX.equalTo(self).offset( SCREEN_WIDTH / 4 - 3)
        }
        self.titleTotalDev.snp.makeConstraints { (make) in
            make.left.equalTo(self.leftView).offset(3)
            make.centerY.equalTo(self.leftView)
        }
        self.valueTotalDev.snp.makeConstraints { (make) in
            make.right.equalTo(self.leftView).offset(-3)
            make.centerY.equalTo(self.leftView)
        }
        self.titleAvailableDev.snp.makeConstraints { (make) in
            
            make.left.equalTo(self.rightView).offset(3)
            make.centerY.equalTo(self.rightView)
        }
        self.valueAvailableDev.snp.makeConstraints { (make) in
            make.right.equalTo(self.rightView).offset(-3)
            make.centerY.equalTo(self.rightView)
        }
    }
}

class MenuDeviceInfoViewCell :FoldingCell{
        //展开时的视图
    let _containerView = Init(DeviceInfoListView(frame: .zero)) {
        $0.backgroundColor = .green
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 5
    }
    //前景视图，收起时的视图
    let _foregroundView = Init(RotatedView(frame: .zero)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 5
    }
    let subView = DeviceTotalView()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder :aDecoder)
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        containerView = _containerView
        foregroundView = _foregroundView
        commonInit()
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type: AnimationType) -> TimeInterval {
        // durations count equal it itemCount
        let durations = [0.26, 0.2, 0.2, 0.2, 0.2, 0.2] // timing animation for each view
        return durations[itemIndex]
    }
}
extension MenuDeviceInfoViewCell {
    //update value to the containerView and foregroundView
    func bind(data: DataModel){
        _containerView.data = data
        subView.valueTotalDev.text = String(describing: data.deviceList!.count)
        subView.valueAvailableDev.text = String(data.numAvailDevice)
        _containerView.tableView.reloadData()
    }
    func setup(){
        self.backgroundColor = UIColor.clear
        subView.backgroundColor = CuColor.colors.v2_ButtonBackgroundColor
        subView.layer.cornerRadius = 5
        self.thmemChangedHandler = { (style) -> Void in
            self._foregroundView.backgroundColor = CuColor.colors.v2_CellWhiteBackgroundColor
        }
        contentView.addSubview(_containerView)
        contentView.addSubview(_foregroundView)
        _foregroundView.addSubview(subView)
        self.itemCount = 6 //如果itemcount = 2 则cv高度必须位fv的两倍
        _containerView.snp.makeConstraints { (make) in
            make.height.equalTo(50 * itemCount)
            make.left.equalTo(6)
            make.right.equalTo(-6)
            self.containerViewTop = make.top.equalTo(3).constraint.layoutConstraints.first
        }
        _foregroundView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(6)
            make.right.equalTo(self.contentView).offset(-6)
            self.foregroundViewTop = make.top.equalTo(self.contentView).offset(3).constraint.layoutConstraints.first
            make.height.equalTo(50) //高度和cell高度相同
        }
        subView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(_foregroundView)
        }
        _foregroundView.layoutIfNeeded()
        _containerView.layoutIfNeeded()
    }

}
