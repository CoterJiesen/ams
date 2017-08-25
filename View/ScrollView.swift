//
//  ScrollViewCell.swift
//  ams
//
//  Created by yangyuan on 2017/6/26.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

import UIKit
import LLCycleScrollView

class SysInfoView: UIView{
    let bview = UIView()
    /// 用户名
    var titleAlocaledLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(15)
        label.text = "分配:"
        label.textColor = .white
        return label
    }()
    /// 用户名
    var valueAlocaledLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(15)
        label.text = "40"
        label.textColor = .white
        return label
    }()
    /// 用户名
    var titleTotalLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(15)
        label.text = "库存:"
        label.textColor = .white
        return label
    }()
    /// 用户名
    var valueTotalLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(15)
        label.text = "100"
        label.textColor = .white
        return label
    }()
    /// 用户名
    var countAlocolLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(40)
        label.text = "40"
        label.textColor = .white
        return label
    }()
    /// 用户名
    var pencentLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(15)
        label.textColor = .white
        label.text = "%"
        return label
    }()
    /// 用户名
    var hasAlocolLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(15)
        label.text = "已分配"
        label.textColor = .white
        return label
    }()
    /// 用户名
    var detailButton: UIButton = {
        let button = UIButton()
        button.setTitle("查看详细", for: UIControlState())
        button.titleLabel?.font = v2Font(15)
        button.tintColor = .white
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
   var prog = OProgressView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        let colors = [UIColor.init(colorLiteralRed: 18.0/255.0, green: 150.0/255.0, blue: 219.0/255.0, alpha: 1.0).cgColor, UIColor.init(colorLiteralRed: 178.0/255.0, green: 226.0/255.0, blue: 248.0/255.0, alpha: 1.0).cgColor]
        bview.layer.initCALayer(frame, colors, [CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1)])
        detailButton.addTarget(self, action: #selector(clickCheckDetail), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func clickCheckDetail(){
        let vc = TabConsumingDetailViewController()
        vc.hidesBottomBarWhenPushed = true
        CuClient.sharedInstance.centerViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    func setupUI(){

        prog.backgroundColor = .clear
        self.addSubview(bview)
        self.addSubview(prog)
        self.addSubview(titleTotalLabel)
        self.addSubview(titleAlocaledLabel)
        self.addSubview(valueTotalLabel)
        self.addSubview(valueAlocaledLabel)
        prog.addSubview(countAlocolLabel)
        prog.addSubview(pencentLabel)
        prog.addSubview(hasAlocolLabel)
        self.addSubview(detailButton)
        setupLayout()
    }
    func setupLayout(){
        self.snp.makeConstraints { (make) in
            make.top.right.left.bottom.equalTo(self)
        }
        
        bview.snp.makeConstraints { (make) in
            make.top.right.left.bottom.equalTo(self)
        }
        self.titleAlocaledLabel.snp.makeConstraints { (make) in
            make.top.equalTo(40)
            make.left.equalTo(30)
        }
        self.valueAlocaledLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleAlocaledLabel)
            make.left.equalTo(titleAlocaledLabel.snp.right).offset(2)
            make.height.equalTo(titleAlocaledLabel)
        }
        self.titleTotalLabel.snp.makeConstraints { (make) in
            make.left.height.equalTo(titleAlocaledLabel)
            make.top.equalTo(titleAlocaledLabel.snp.bottom).offset(6)
        }
        self.valueTotalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleTotalLabel)
            make.left.equalTo(valueAlocaledLabel)
            make.height.equalTo(titleTotalLabel)
        }
        self.prog.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.height.width.equalTo(120)
        }
        self.countAlocolLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self.prog).offset(-10)
        }
        self.pencentLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(countAlocolLabel).offset(-5)
            make.left.equalTo(countAlocolLabel.snp.right).offset(2)
        }
        self.hasAlocolLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.prog)
            make.top.equalTo(countAlocolLabel.snp.bottom)
        }
        self.detailButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-30)
            make.right.equalTo(-20)
            make.width.equalTo(80)
        }
    }
}
class ScrollView: UIView{
    
    override init(frame : CGRect){
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        // 网络图，本地图混合
        let imagesURLStrings = [
            "30.jpg",
//            "ic_scoll_1",
//            "ic_scoll_2",
//            "ic_scoll_3",
//            "ic_scoll_4",
            ];
        
        // 图片配文字
        let titles = ["感谢您的支持",
                      "欢迎使用资产管理系统",
        ];
        let menu =  SysInfoView()
        
        menu.backgroundColor = CuColor.colors.v2_ButtonBackgroundColor
        let views = [
           menu,
        ];
        // Demo--点击回调
        let introduceScro = LLCycleScrollView.llCycleScrollViewWithFrame(CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: (SCREEN_HEIGHT - 64 - 49) / 3 + 12), views: views, imageURLPaths: imagesURLStrings, titles:titles, didSelectItemAtIndex: { index in
            print("当前点击图片的位置为:\(index)")
        })
        introduceScro.customPageControlStyle = .pill
        introduceScro.autoScrollTimeInterval = 3.0
        introduceScro.customPageControlInActiveTintColor = UIColor.red
        // 下边约束
        introduceScro.pageControlBottom = 2
        self.addSubview(introduceScro)
    }
}
