//
//  ReportFaultDeviceViewController.swift
//  ams
//
//  Created by yangyuan on 2017/7/31.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//



import UIKit
import PagingMenuController
import PieCharts

class ConsumingAllocInfoView: UIView{
    let bview = StarsOverlay()
    var avatarView: UIView = {
        let mview = UIView()
        mview.backgroundColor = UIColor(white: 0.9, alpha: 0.3)
        mview.layer.borderWidth = 1.5
        mview.layer.borderColor = UIColor(white: 1, alpha: 0.6).cgColor
        mview.layer.masksToBounds = true
        mview.layer.cornerRadius = SCREEN_WIDTH/4
        return mview
    }()

  
    var numLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(25)
        label.text = "5"
        label.textColor = .white
        return label
    }()

    var numTitleLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(20)
        label.text = "已分配"
        label.textColor = .red
        return label
    }()
    override init(frame : CGRect){
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI(){
        self.addSubview(bview)
        self.addSubview(avatarView)
        avatarView.addSubview(numLabel)
        avatarView.addSubview(numTitleLabel)
        setupLayout()
    }
    func setupLayout(){
        self.snp.makeConstraints { (make) in
            make.top.right.left.bottom.equalTo(self)
        }
        self.bview.snp.makeConstraints { (make) in
            make.top.right.left.bottom.equalTo(self)
        }
        self.avatarView.snp.makeConstraints{ (make) -> Void in
            make.center.equalTo(self)
            make.width.height.equalTo(self.avatarView.layer.cornerRadius * 2)
        }
        self.numLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(avatarView)
            make.centerY.equalTo(avatarView).offset(-20)
        }
        self.numTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(avatarView)
            make.centerY.equalTo(avatarView).offset(10)
        }
    }
}
//分页菜单配置
private struct PagingMenuOptions: PagingMenuControllerCustomizable {
    //第1个子视图控制器
    private let viewController1 = MyAllocationViewController()
    //第2个子视图控制器
    private let viewController2 = MyConsumingViewController()
    
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
            return .text(title: MenuItemText(text: "我的分配"))
        }
    }
    
    //第2个菜单项
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "我的领用"))
        }
    }
}

struct PersonConsumingInfo{
    var name: String
    var num: Int
    var color: UIColor
    init(){
        name = ""
        num = 0
        color = UIColor()
    }
}

//主视图控制器
class TabConsumingDetailViewController: UIViewController {
    var titleView = ConsumingAllocInfoView()
    let bview = StarsOverlay()
    var topview = UIView()
    var chartView =  PieChart()
    var viewController1: MyAllocationViewController!
    //第2个子视图控制器
    var viewController2 : MyConsumingViewController!
    
    var modelInfo: Array<PersonConsumingInfo>?{
        didSet{
            chartView.models = createModels(infos: modelInfo!)
            viewController1.modelInfo = modelInfo!
        }
    }
    var allocHistoryList :[allocHistory]?{
        didSet{
            viewController2.allocHistoryList = allocHistoryList
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .green
        //获取分页菜单配置
        let options = PagingMenuOptions()
        viewController1 = options.pagingControllers[0] as! MyAllocationViewController
        viewController2 = options.pagingControllers[1] as! MyConsumingViewController
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
        self.view.addSubview(topview)
//        self.view.addSubview(titleView)
//        titleView.backgroundColor = CuColor.colors.v2_ButtonBackgroundColor
//        titleView.snp.makeConstraints { (make) in
//            make.top.equalTo(64)
//            make.height.equalTo(SCREEN_HEIGHT/3)
//            make.width.equalTo(SCREEN_WIDTH)
//            make.left.equalTo(self.view)
//        }
        topview.addSubview(chartView)
        chartView.addSubview(bview)
        chartView.backgroundColor = UIColor(patternImage: UIImage(named: "12.jpg")!)// CuColor.colors.v2_ButtonBackgroundColor
        topview.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(64)
            make.left.right.equalTo(self.view)
            make.height.equalTo(SCREEN_HEIGHT/3)
        }
        chartView.snp.makeConstraints { (make) in
            make.height.equalTo(SCREEN_HEIGHT/3)
            make.width.equalTo(SCREEN_WIDTH)
            make.center.equalTo(topview)
        }
        self.bview.snp.makeConstraints { (make) in
            make.top.right.left.bottom.equalTo(self.chartView)
        }
        
        pagingMenuController.didMove(toParentViewController: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        getMangerAllocHistory()
        chartView.layers = [createPlainTextLayer(), createTextWithLinesLayer()]
        chartView.innerRadius = 50
        chartView.outerRadius = 70
        chartView.selectedOffset = 6
        chartView.delegate = self

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getMangerAllocHistory(){
        DataModel.alloctionDeviceHistory(username: CuUser.sharedInstance.username!){
            (response:CuValueResponse<[allocHistory]>) -> Void in
            if response.success{
                if let value = response.value{
                    self.allocHistoryList =  value
                    var modelInfo = [PersonConsumingInfo]()
                    for e in self.allocHistoryList!.enumerated() {
                        if "" != e.element.name && !modelInfo.contains(where: {$0.name == e.element.name}){
                            var info = PersonConsumingInfo()
                            info.name = e.element.name
                            info.num = self.allocHistoryList!.filter({$0.name == info.name}).count
                            info.color = UIColor.randomColor()
                            modelInfo.append(info)
                        }
                    }
                    self.modelInfo = modelInfo
                }
                
            }
        }
    }
}
extension TabConsumingDetailViewController: PieChartDelegate {
    func onSelected(slice: PieSlice, selected: Bool) {
        print("Selected: \(selected), slice: \(slice)")
    }

    
    // MARK: - Models
    
    fileprivate func createModels(infos: Array<PersonConsumingInfo>) -> [PieSliceModel] {
        
        var models = [PieSliceModel]()
            
        for e in infos{
            models.append(PieSliceModel(value: Double(e.num), color: e.color))
        }
        return models
    }

    // MARK: - Layers
    
    fileprivate func createPlainTextLayer() -> PiePlainTextLayer {
        
        let textLayerSettings = PiePlainTextLayerSettings()
        textLayerSettings.viewRadius = 55
        textLayerSettings.hideOnOverflow = true
        textLayerSettings.label.font = UIFont.systemFont(ofSize: 8)
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        textLayerSettings.label.textColor = .white
        textLayerSettings.label.textGenerator = {slice in
            return formatter.string(from: slice.data.percentage * 100 as NSNumber).map{"\($0)%"} ?? ""
        }
        
        let textLayer = PiePlainTextLayer()
        textLayer.settings = textLayerSettings
        return textLayer
    }
    
    fileprivate func createTextWithLinesLayer() -> PieLineTextLayer {
        let lineTextLayer = PieLineTextLayer()
        var lineTextLayerSettings = PieLineTextLayerSettings()
        lineTextLayerSettings.lineColor = UIColor.lightGray
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        lineTextLayerSettings.label.font = UIFont.systemFont(ofSize: 14)
        lineTextLayerSettings.label.textColor = .white
        lineTextLayerSettings.label.textGenerator = {slice in
            return formatter.string(from: slice.data.model.value as NSNumber).map{"\($0)"} ?? ""
        }
        
        lineTextLayer.settings = lineTextLayerSettings
        return lineTextLayer
    }

}
