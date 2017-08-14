//
//  AllocateDeviceViewCell.swift
//  ams
//
//  Created by yangyuan on 2017/7/13.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit

extension UITableViewCell {
    //返回cell所在的UITableView
    func superTableView() -> UITableView? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let tableView = view as? UITableView {
                return tableView
            }
        }
        return nil
    }
}
class AllocateDeviceViewCell: UITableViewCell{
    let content = UIView()
    let lableSN = UILabel()
    let onOffButton = OnOffButton()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    required override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    func setupUI(){
        onOffButton.frame = CGRect(origin: .zero, size:CGSize(width: 26,height: 26))
        onOffButton.lineWidth = 2
//        onOffButton.strokeColor = .white //CuColor.colors.v2_ButtonBackgroundColor
        onOffButton.ringAlpha = 0.3
//        onOffButton.addTarget(self, action: #selector(didTapOnOffButton), for : .touchUpInside)
        onOffButton.checked = false
        onOffButton.isUserInteractionEnabled = false
        self.backgroundColor =  .clear
        self.selectionStyle = .none
        self.layer.cornerRadius = 6
        self.contentView.addSubview(self.content)
        self.content.addSubview(lableSN)
        self.content.addSubview(onOffButton)
//        content.layer.cornerRadius = 6
        content.backgroundColor = CuColor.colors.v2_ButtonBackgroundColor
        
        content.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView)
            make.top.equalTo(self.contentView).offset(1)
            make.bottom.equalTo(self.contentView).offset(-1)
            make.right.equalTo(self.contentView)
        }
        
        lableSN.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.content)
            make.left.equalTo(self.content).offset(6)
            make.width.equalTo(4 * SCREEN_WIDTH / 5)
        }
        onOffButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.content)
            make.right.equalTo(self.content).offset(-5)
        }
    }
    func bind(sn: String){
        self.lableSN.text = sn
    }
    func didTapOnOffButton() {
        onOffButton.checked = !onOffButton.checked
        let tableview = superTableView()
        let indexPath = tableview?.indexPath(for: self)
        print("indexPath：\(indexPath!)")
        
    }
}
