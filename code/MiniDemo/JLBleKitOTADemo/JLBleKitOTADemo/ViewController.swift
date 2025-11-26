//
//  ViewController.swift
//  JLBleKitOTADemo
//
//  Created by EzioChan on 2025/11/25.
//

import UIKit
import JLLogHelper
import RxSwift
import RxCocoa
import SnapKit
import JL_BLEKit
import CoreBluetooth

/// 单页面演示的主控制器，负责展示扫描、更新按钮及状态与进度布局
class ViewController: UIViewController {
    
    let subTableView = UITableView()
    let scanBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Scan", for: .normal)
        btn.backgroundColor = .blue
        return btn
    }()
    let startUpdateBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Start Update", for: .normal)
        btn.backgroundColor = .blue
        return btn
    }()
    
    let stateLabel: UILabel = {
        let label = UILabel()
        label.text = "State"
        return label
    }()

    let progress = UIProgressView(progressViewStyle: .default)
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        setupBind()
        bindAction()
    }
    
    func setupUI(){
        view.backgroundColor = .systemBackground
        view.addSubview(stateLabel)
        view.addSubview(progress)
        view.addSubview(subTableView)
        view.addSubview(scanBtn)
        view.addSubview(startUpdateBtn)

        scanBtn.setTitleColor(.white, for: .normal)
        startUpdateBtn.setTitleColor(.white, for: .normal)
        scanBtn.layer.cornerRadius = 8
        scanBtn.clipsToBounds = true
        startUpdateBtn.layer.cornerRadius = 8
        startUpdateBtn.clipsToBounds = true

        subTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        subTableView.tableFooterView = UIView()
        subTableView.rowHeight = UITableView.automaticDimension
        subTableView.estimatedRowHeight = 50
        
    }
    
    func setupLayout(){
        stateLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
        }

        progress.snp.makeConstraints { make in
            make.top.equalTo(stateLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
        }

        scanBtn.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(44)
        }

        startUpdateBtn.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(44)
            make.leading.equalTo(scanBtn.snp.trailing).offset(12)
            make.width.equalTo(scanBtn.snp.width)
        }

        subTableView.snp.makeConstraints { make in
            make.top.equalTo(progress.snp.bottom).offset(12)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(scanBtn.snp.top).offset(-12)
        }
    }
    
    
    func setupBind(){
        BleManager.shared.discoverPeripheralsSubject.bind(to: subTableView.rx.items(cellIdentifier: "cell")) { _, entity, cell in
            cell.textLabel?.text = entity.mItem
            if entity.mPeripheral.identifier.uuidString == BleManager.shared.currentUUID {
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        }
        .disposed(by: disposeBag)
        
        OTAActionManager.shared.updateStateSubject.subscribe(onNext: { [weak self] state, progress in
            guard let self = self else { return }
            self.stateLabel.text = state
            self.progress.progress = progress
        })
        .disposed(by: disposeBag)
        
        OTAActionManager.shared.prepareUpdateSubject.subscribe(onNext: { _ in
            JLLogManager.logLevel(.DEBUG, content: "prepare update")
            self.subTableView.reloadData()
        })
        .disposed(by: disposeBag)
        
        
    }
    
    
    func bindAction(){
        scanBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard self != nil else { return }
            JLLogManager.logLevel(.DEBUG, content: "scan")
            BleManager.shared.startScan()
        }).disposed(by: disposeBag)
        
        startUpdateBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard self != nil else { return }
            JLLogManager.logLevel(.DEBUG, content: "start update")
            guard let dataUrl = Bundle.main.url(forResource: "update", withExtension: "ufw") else { return }
            guard let data = try?Data(contentsOf: dataUrl) else { return }
            OTAActionManager.shared.startOta(data: data)
        }).disposed(by: disposeBag)
        
        subTableView.rx.modelSelected(JL_EntityM.self).subscribe(onNext: { entity in
            JLLogManager.logLevel(.DEBUG, content: "select peripheral")
            if entity.mPeripheral.identifier.uuidString == BleManager.shared.currentUUID {
                BleManager.shared.disconnect(entity: entity)
                return
            }
            BleManager.shared.connect(entity: entity)
        }).disposed(by: disposeBag)
    }
}

