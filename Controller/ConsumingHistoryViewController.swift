//
//  ConsumingHistoryViewController.swift
//  ams
//
//  Created by yangyuan on 2017/7/28.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//


import UIKit

class ConsumingHistoryViewController:UIViewController,UITextFieldDelegate{
    var allocHistoryList :[allocHistory]?
    var allocHistoryListBak :[allocHistory]?
    let contentTextField = UITextField() //SearchTextField(frame: CGRect(x:0, y:0, width: SCREEN_WIDTH, height: 40))
    let text = UITextField()
    
    //输入框的高度
    let txtFieldHeight = 40

    
    fileprivate var _tableView :UITableView!
    fileprivate var tableView: UITableView {
        get{
            if(_tableView != nil){
                return _tableView!;
            }
            _tableView = UITableView();
            //            _tableView.separatorStyle = UITableViewCellSeparatorStyle.none;
            
            regClass(_tableView, cell: ConsumingHistoryViewCell.self);
            
            _tableView.delegate = self
            _tableView.dataSource = self
            _tableView.sectionHeaderHeight = 30
            return _tableView!;
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setup()
        contentTextField.addTarget(self, action:#selector(textFieldDidChange), for: .editingChanged)
        contentTextField.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
         getMangerAllocHistory()
    }
    
    func textFieldDidChange(){
        if let num = allocHistoryList?.count, let numbak = allocHistoryListBak?.count, num + numbak <= 0 {
            return
        }else{
            if let text = contentTextField.text ,text.Lenght > 0 {
                if allocHistoryListBak == nil{
                    allocHistoryListBak = allocHistoryList
                }
                var allocHistoryListtmp = [allocHistory]()
                var flg = false
                for e in allocHistoryListBak!{
                    if e.dvInfo.SN.range(of: text) != nil{
                        allocHistoryListtmp.append(e)
                        flg = true
                    }
                }
                if flg {
                    allocHistoryList = allocHistoryListtmp
                }else{
                    allocHistoryList = []
                }
            }else{
                allocHistoryList = allocHistoryListBak
            }
        }
        self.tableView.reloadData()
    }
    
    func getMangerAllocHistory(){
        DataModel.alloctionDeviceHistory(username: CuUser.sharedInstance.username!){
            (response:CuValueResponse<[allocHistory]>) -> Void in
            if response.success{
                if let value = response.value{
                     self.allocHistoryList =  value
                     self.tableView.reloadData()
                }

            }
        }
    }
 
    func setup(){

        tableView.backgroundColor =  CuColor.colors.v2_backgroundColor
        tableView.layer.borderColor = UIColor.white.cgColor
        tableView.layer.borderWidth = 0.5
//        contentTextField.filterStrings(["gfh","fdgds","213"])
        contentTextField.backgroundColor = CuColor.colors.v2_backgroundColor
        contentTextField.placeholder = "请输入关键字"
        let imgSearch =  UIImageView(frame:CGRect(x: 10, y: 11, width: txtFieldHeight/2, height: txtFieldHeight/2))
        imgSearch.image = UIImage(named:"search")
        contentTextField.leftView = UIView(frame:CGRect(x: 0, y: 0, width: txtFieldHeight, height: txtFieldHeight))
        contentTextField.leftView!.addSubview(imgSearch)
        contentTextField.leftViewMode = .always
        self.view.addSubview(tableView)
        self.view.addSubview(contentTextField)
        setupLayout()
        
    }
    func setupLayout(){
        contentTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(3)
            make.left.equalTo(self.view)
            make.height.equalTo(txtFieldHeight)
            make.width.equalTo(SCREEN_WIDTH)
        }

        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(contentTextField.snp.bottom).offset(6)
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

}
//重载tableview相关函数
extension ConsumingHistoryViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let num = allocHistoryList?.count, num > 0 {
            return num
        }
        return  0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = getCell(tableView, cell: ConsumingHistoryViewCell.self, indexPath: indexPath);
     
        if let value = allocHistoryList?[indexPath.row]{
            cell.bind(data: value)
        }
        return cell;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
