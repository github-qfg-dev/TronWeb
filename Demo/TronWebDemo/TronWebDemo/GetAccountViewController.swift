//
//  GetAccountViewController.swift
//  TronKit
//
//  Created by Charles on 2022/8/30.
//

import Foundation
import TronWeb
import UIKit
class GetAccountViewController: UIViewController {
    var chainType: ChainType = .nile
    var operationType: OperationType = .getAccount
    lazy var tronWeb: TronWeb3 = {
        let tronweb = TronWeb3()
        return tronweb
    }()

    lazy var getAccountBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("帳戶査詢", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(getAccountAction), for: .touchUpInside)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        return btn
    }()
    
    lazy var addressField: UITextField = {
        let addressField = UITextField()
        addressField.borderStyle = .line
        addressField.placeholder = "査詢地址輸入框"
        addressField.text = "TNUC9Qb1rRpS5CbWLmNMxXBjyFoydXjWFR"
        return addressField
    }()
    
    lazy var accountInfoTextView: UITextView = {
        let textView = UITextView()
        textView.text = "地址資訊…"
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.brown.cgColor
        return textView
    }()
    
    init(_ chainType: ChainType, _ operationType: OperationType) {
        super.init(nibName: nil, bundle: nil)
        self.chainType = chainType
        self.operationType = operationType
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    deinit {
        print("\(type(of: self)) release")
    }

    func setupView() {
        setupNav()
        setupContent()
    }

    func setupNav() {
        title = chainType == .main ? "主網獲取帳戶資訊" : "Nile測試網獲取帳戶資訊"
    }

    func setupContent() {
        view.backgroundColor = .white
        view.addSubviews(getAccountBtn, addressField, accountInfoTextView)
        getAccountBtn.snp.makeConstraints { make in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.bottom.equalTo(-100)
            make.height.equalTo(40)
        }
        addressField.snp.makeConstraints { make in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.top.equalTo(150)
            make.height.equalTo(40)
        }
        
        accountInfoTextView.snp.makeConstraints { make in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.top.equalTo(addressField.snp.bottom).offset(20)
            make.height.equalTo(288)
        }
    }

    func isTRXAddress(address: String) {
        tronWeb.isTRXAddress(address: address) { [weak self] result in
            guard let self = self else { return }
            if result {
                self.getAccount(address: address)
            } else {
                self.accountInfoTextView.text = "波場地址格式錯誤"
            }
        }
    }

    func getAccount(address: String) {
        tronWeb.getAccount(address: address) { [weak self] dic in
            guard let self = self else { return }
            let text = dicValueString(dic)
            self.accountInfoTextView.text = text
        }
    }

    @objc func getAccountAction() {
        guard let address = addressField.text else { return }
        if tronWeb.isGenerateTronWebInstanceSuccess != true {
            tronWeb.setup(privateKey: "01", node: chainType == .main ? TRONMainNet : TRONNileNet) { [weak self] setupResult in
                guard let self = self else { return }
                if setupResult {
                    self.isTRXAddress(address: address)
                }
            }
        } else {
            isTRXAddress(address: address)
        }
    }
}
