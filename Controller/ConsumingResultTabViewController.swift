//
//  ReportFaultDeviceViewController.swift
//  ams
//
//  Created by yangyuan on 2017/7/31.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//



import UIKit
import PagingMenuController

class ConsumingInfoView: UIView{
    
    /// 用户名
    var numSuccLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(25)
        label.text = "5"
        label.textColor = .white
        return label
    }()
    /// 用户名
    var numFaultLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(20)
        label.text = "3"
        label.textColor = .red
        return label
    }()
    /// 用户名
    var succLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(18)
        label.text = " 台领用成功"
        label.textColor = .white
        return label
    }()
    /// 用户名
    var faultLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(16)
        label.text = " 台领用失败"
        label.textColor = .white
        return label
    }()
    var image: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "pd1")
        return img
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI(){
        self.addSubview(numSuccLabel)
        self.addSubview(numFaultLabel)
        self.addSubview(succLabel)
        self.addSubview(faultLabel)
        self.addSubview(image)
        setupLayout()
    }
    func setupLayout(){
        self.snp.makeConstraints { (make) in
            make.top.right.left.bottom.equalTo(self)
        }
        self.faultLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-20)
            make.centerX.equalTo(self)
            make.height.equalTo(20)
        }
        self.numFaultLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(faultLabel)
            make.right.equalTo(faultLabel.snp.left)
        }
        self.succLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(faultLabel.snp.top).offset(-10)
            make.centerX.equalTo(self)
            make.height.equalTo(20)
        }
        self.numSuccLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(succLabel)
            make.right.equalTo(succLabel.snp.left)
        }
        
        self.image.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(10)
            make.bottom.equalTo(succLabel.snp.top).offset(-10)
            make.width.equalTo(image.snp.height)
        }
    }
}
//分页菜单配置
private struct PagingMenuOptions: PagingMenuControllerCustomizable {
    //第1个子视图控制器
    private let viewController1 = ConsumingSuccessViewController()

    //第2个子视图控制器
    private let viewController2 = ConsumingFaultViewController()
    
    //组件类型
    fileprivate var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    
    //所有子视图控制器
    fileprivate var pagingControllers: [UIViewController] {
        return [viewController1, viewController2]
    }
    
    //菜单配置项
    fileprivate struct MenuOptions: MenuViewCustomizable {
        //菜单显示模式
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        //菜单项
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2()]
        }
    }
    
    //第1个菜单项
    fileprivate struct MenuItem1: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "成功"))
        }
    }
    
    //第2个菜单项
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "失败"))
        }
    }

}

//主视图控制器
class ConsumingResultTabViewController: UIViewController {
    var succList = [deviceInfo]()
    var failList = [allocfailDevice]()
    var titleView = ConsumingInfoView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //获取分页菜单配置
        let options = PagingMenuOptions()

        let vc1 = options.pagingControllers[0] as! ConsumingSuccessViewController
            vc1.succList = succList
        let vc2 = options.pagingControllers[1] as! ConsumingFaultViewController
            vc2.failList = failList
        
        
        titleView.numSuccLabel.text = String(succList.count)
        titleView.numFaultLabel.text = String(failList.count)
        //设置分页菜单配置
        let pagingMenuController =  PagingMenuController(options: options)
        pagingMenuController.view.frame.origin.y += (64 + SCREEN_HEIGHT/3)
        pagingMenuController.view.frame.size.height -= (64 + SCREEN_HEIGHT/3)
        pagingMenuController.onMove = { state in
            switch state {
            case let .willMoveController(menuController, previousMenuController):
                print(previousMenuController)
                print(menuController)
            case let .didMoveController(menuController, previousMenuController):
                print(previousMenuController)
                print(menuController)
            case let .willMoveItem(menuItemView, previousMenuItemView):
                print(previousMenuItemView)
                print(menuItemView)
            case let .didMoveItem(menuItemView, previousMenuItemView):
                print(previousMenuItemView)
                print(menuItemView)
            case .didScrollStart:
                print("Scroll start")
            case .didScrollEnd:
                print("Scroll end")
            }
        }
        
        self.addChildViewController(pagingMenuController)
        self.view.addSubview(pagingMenuController.view)
        self.view.addSubview(titleView)
        titleView.backgroundColor = CuColor.colors.v2_ButtonBackgroundColor
        titleView.snp.makeConstraints { (make) in
            make.top.equalTo(64)
            make.height.equalTo(SCREEN_HEIGHT/3)
            make.width.equalTo(SCREEN_WIDTH)
            make.left.equalTo(self.view)
        }
        pagingMenuController.didMove(toParentViewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
