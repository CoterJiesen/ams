//
//  ReportFaultDeviceViewController.swift
//  ams
//
//  Created by yangyuan on 2017/7/31.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//



import UIKit

class ReportFaultDeviceViewController:UIViewController,UITextFieldDelegate,scanDelegate,ZHDropDownMenuDelegate{
    var deviceList : [deviceInfo]?
    //存储选中单元格的索引
    var selectedIndexs = [Int]()
    
    var choseMangerNum : Int = 0
    let barCode  = UITextField()  //条码
    //输入框的高度
    let txtFieldHeight = 40
    var scanButton: UIButton = {
        //创建一个图片一个文字的按钮
        let button = UIButton()
        button.setImage(UIImage(named: "scan_blue"), for: .normal)
        return button
    }()
    let titleLable = UILabel()

    
    let reportButton = UIButton()
    let buttonView = UIView()
    
    fileprivate var _tableView :UITableView!
    fileprivate var tableView: UITableView {
        get{
            if(_tableView != nil){
                return _tableView!;
            }
            _tableView = UITableView();
            regClass(_tableView, cell: DeviceInfoViewCell.self);
            
            _tableView.delegate = self
            _tableView.dataSource = self
            _tableView.sectionHeaderHeight = 40
            return _tableView!;
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setup()
        
        scanButton.addTarget(self, action: #selector(scanBtnClicked), for: .touchUpInside)
        reportButton.addTarget(self, action: #selector(reportFalutForManger), for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        getListReportFalut()
    }

 
    func getListReportFalut(){
        
        DataModel.reporFalutDevice(username: CuUser.sharedInstance.username!){
            (response:CuValueResponse<[deviceInfo]>) -> Void in
            if response.success {
                if let list = response.value{
                    self.deviceList = list
                    self.tableView.reloadData()
                }
            }
        }
    }
    func reportFalutForManger(){
    
        if selectedIndexs.count > 0 {
            var sns = [String]()
            for e in selectedIndexs.enumerated(){
                sns.append(deviceList![e.element].SN)
            }
            let strSns = sns.joined(separator: ",")
            CuBeginLoadingWithStatus("数据传输中！！！")
            DataModel.reportFalutDeviceAction(strSns: strSns, username: CuUser.sharedInstance.username!){
                (response: CuValueResponse<[retAllocDeviceStatus]>) -> Void in
                if response.success {
                    CuEndLoading()
                    if let value = response.value {
                        var succList = [deviceInfo]()
                        var failList = [allocfailDevice]()
                        for info in value{
                            if info.ret{
                                if let num = self.deviceList?.count, num > 0 && self.deviceList!.contains(where: {$0.SN == info.sn}){
                                    let index = self.deviceList!.index(where: {$0.SN == info.sn})!
                                    succList.append(self.deviceList![index])
                                }
                            }else{
                                if let num = self.deviceList?.count, num > 0 && self.deviceList!.contains(where: {$0.SN == info.sn}){
                                    let index = self.deviceList!.index(where: {$0.SN == info.sn})!
                                    var failDevice = allocfailDevice()
                                    failDevice.dvInfo = self.deviceList![index]
                                    failDevice.reason = info.failReason
                                    failList.append(failDevice)
                                }
                            }
                        }
                        
                        let vc = ConsumingResultTabViewController()
                        vc.titleView.faultLabel.text = " 台报障失败"
                        vc.titleView.succLabel.text = " 台报障成功"
                        
                        vc.succList = succList
                        vc.failList = failList
                        CuClient.sharedInstance.centerViewController?.navigationController?.pushViewController(vc, animated: true)
                        print(value)
                    }
                    
                }
            }
            
        }else{
            CuError("请选择设备！")
        }

    }
    func setup(){

        //条码
//        let leftView = UIImageView(image : UIImage(named:"icon_code"))
//        leftView.frame = CGRect(x: 6, y: 11, width: txtFieldHeight-12, height: txtFieldHeight-22)
        scanButton.frame = CGRect(x: -4, y: 4, width: txtFieldHeight, height: txtFieldHeight-8)
        barCode.keyboardType = .asciiCapable
        barCode.delegate = self
        barCode.placeholder = "输入或扫描条码"
        barCode.text = "ZTEGC7F1930A"
        barCode.tag = 100
        barCode.font = v2Font(16)
        //        barCode.textColor = UIColor.white
        barCode.leftViewMode = .always
        barCode.rightViewMode = .always
        barCode.leftView =  UIView(frame:CGRect(x: 0, y: 0, width: 10, height: txtFieldHeight))
        barCode.rightView = UIButton(frame:CGRect(x: 0, y: 0, width:txtFieldHeight, height: txtFieldHeight))
        barCode.layer.borderColor = CuColor.colors.v2_backgroundColor.cgColor
        barCode.layer.borderWidth = 2
//        barCode.layer.cornerRadius = 5
//        barCode.leftView!.addSubview(leftView)
        barCode.rightView!.addSubview(scanButton)
        
        //按钮
        reportButton.setTitle("报障", for: UIControlState())
        reportButton.titleLabel!.font = v2Font(20)
        reportButton.layer.cornerRadius = 3;
        reportButton.layer.borderWidth = 1
        reportButton.backgroundColor = CuColor.colors.v2_ButtonBackgroundColor
        reportButton.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor;
        
        tableView.backgroundColor = .clear
        tableView.layer.borderColor = UIColor.white.cgColor
        tableView.layer.borderWidth = 0.5
        //        tableView.layer.cornerRadius = 5
        self.thmemChangedHandler = {[weak self] (style) -> Void in
            self?.buttonView.backgroundColor = CuColor.colors.v2_CellWhiteBackgroundColor
            self?.view.backgroundColor = CuColor.colors.v2_backgroundColor
            self?.tableView.backgroundColor = CuColor.colors.v2_CellWhiteBackgroundColor
            self?.barCode.backgroundColor = CuColor.colors.v2_CellWhiteBackgroundColor
        }
        
        self.view.addSubview(barCode)
        buttonView.addSubview(reportButton)
        self.view.addSubview(tableView)
        self.view.addSubview(buttonView)

        setupLayout()
        
    }
    func setupLayout(){
        barCode.snp.makeConstraints { (make) in
            make.top.equalTo(6)
            make.centerX.equalTo(self.view)
            make.height.equalTo(txtFieldHeight)
            make.width.equalTo(SCREEN_WIDTH)
        }

        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(self.barCode)
            make.right.equalTo(self.barCode)
            make.top.equalTo(self.barCode.snp.bottom)
            make.bottom.equalTo(self.buttonView.snp.top).offset(-10)
        }
        buttonView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(self.view)
            make.height.equalTo(txtFieldHeight + 20)
            
        }
        reportButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.buttonView).offset(10)
            make.right.equalTo(self.buttonView).offset(-10)
            make.top.equalTo(self.buttonView).offset(10)
            make.bottom.equalTo(self.buttonView).offset(-10)
        }
    }

    //MARK: - 点击文本框外收回键盘
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.awayKeyboard))
        tap.cancelsTouchesInView = false //是否取消点击处的其他action
        view.addGestureRecognizer(tap)
    }
    //恢复view位置
    func awayKeyboard(){
        //收起键盘
        self.view.endEditing(true)
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        scanBtnClicked()
        return false
    }
    //代理方法实现
    func passBarcodeValue(title: String, message: String) {
        let strNoNewline = message.replacingOccurrences(of: "\n", with: " ")
        var array = strNoNewline.components(separatedBy: " ")
        var reLoad = false
        for e in array.enumerated().reversed(){
            if "" != e.element{
                if let num = deviceList?.count, num > 0 && deviceList!.contains(where: {$0.SN == e.element}){
                    let index = self.deviceList!.index(where: {$0.SN == e.element})
                    if !selectedIndexs.contains(index!){
                        selectedIndexs.append(index!)
                    }
                    barCode.text = e.element
                    reLoad = true
                }else {
                    CuError("SN:\(e.element) 不存在！")
                }
            }else{
                array.remove(at: e.offset)
            }
        }
        if reLoad{
            tableView.reloadData()
        }
        print(title)
    }
    //扫描条码
    func scanBtnClicked(){
        let vc = ScanViewController();
        //设置代理
        vc.delegate = self
        var style = LBXScanViewStyle()
        style.animationImage = UIImage(named: "qrcode_scan_light_green")
        vc.scanStyle = style
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true);
        //        CuClient.sharedInstance.centerViewController!.navigationController?.pushViewController(vc, animated: true);
    }

    //选择完后回调
    func dropDownMenu(_ menu: ZHDropDownMenu!, didChoose index: Int) {
        print("\(menu) choosed at index \(index)")
    }
    
    //编辑完成后回调
    func dropDownMenu(_ menu: ZHDropDownMenu!, didInput text: String!) {
        print("\(menu) input text \(text)")
    }
    
}
//重载tableview相关函数
extension ReportFaultDeviceViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let num = deviceList?.count{
            return num
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // 设置 section 的 header 文字
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //return "已选(\(selectedIndexs.count))台"
        let headerView = UIView(frame:CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        headerView.backgroundColor = CuColor.colors.v2_backgroundColor
        titleLable.text = "已选(\(selectedIndexs.count))台"
        let lable = UILabel()
        lable.text = "待报障设备"
        headerView.addSubview(titleLable)
        headerView.addSubview(lable)
        lable.snp.makeConstraints { (make) in
            make.centerY.equalTo(headerView)
            make.width.equalTo( SCREEN_WIDTH / 2)
            make.height.equalTo(20)
            make.left.equalTo(headerView).offset(10)
        }

        titleLable.snp.makeConstraints { (make) in
            make.right.equalTo(headerView).offset(-5)
            make.top.equalTo(lable).offset(-3)
            make.height.equalTo(30)
        }
        
        return headerView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = getCell(tableView, cell: DeviceInfoViewCell.self, indexPath: indexPath);
        cell.content.onOffButton.strokeColor = CuColor.colors.v2_ButtonBackgroundColor
        if let device = deviceList?[indexPath.row]{
            cell.bind(data: device)
        }
        //判断是否选中（选中单元格尾部打勾）
        if selectedIndexs.contains(indexPath.row) {
            cell.content.onOffButton.checked = true
        } else {
            cell.content.onOffButton.checked = false
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DeviceInfoViewCell
        //判断该行原先是否选中
        if let index = selectedIndexs.index(of: indexPath.row){
            cell.content.onOffButton.checked = false
            selectedIndexs.remove(at: index) //原来选中的取消选中
            titleLable.text = "已选(\(selectedIndexs.count))台"
        }else{
            cell.content.onOffButton.checked = true
            selectedIndexs.append(indexPath.row) //原来没选中的就选中
            titleLable.text = "已选(\(selectedIndexs.count))台"
        }
    }
}
