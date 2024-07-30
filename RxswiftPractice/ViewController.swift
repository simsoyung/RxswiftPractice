//
//  ViewController.swift
//  RxswiftPractice
//
//  Created by 심소영 on 7/30/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    let pickerView = UIPickerView()
    let pickerLabel = UILabel()
    let tableView = UITableView()
    let tableLabel = UILabel()
    let rxSwitch = UISwitch()
    let switchLabel = UILabel()
    let signName = UITextField()
    let signEmail = UITextField()
    let textFieldLabel = UILabel()
    let signButton = UIButton()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
        setPickerView()
        setTableView()
        setSwitch()
        setSign()
    }

    private func setPickerView(){
        let items = Observable.just(TextInput.PickerView.allCases)
        
        items
            .bind(to: pickerView.rx.itemTitles) { (row, element) in
                return element.rawValue
            }
            .disposed(by: disposeBag)
        
        pickerView.rx.modelSelected(TextInput.PickerView.self) //들어오는거 타입 맞춰야함!
            .map { $0.first?.rawValue}
            .bind(to: pickerLabel.rx.text)
            .disposed(by: disposeBag)
    }
    private func setTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        let items = Observable.just(TextInput.TableView.allCases)
        items
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "\(element.rawValue) @row \(row)"
                return cell
            }
            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.itemSelected,
                       tableView.rx.modelSelected(TextInput.TableView.self))
//        .bind(with: self) { owner, value in
//            let (index, model) = value
//            owner.tableLabel.text = "section:\(index.section),row:\(index.row),data: \(model.rawValue)"
//        }
        .bind(with: self){ owner, value in
            owner.tableLabel.text = " index: \(value.0) data: \(value.1)" //string 넣으려면 rawValue
        }
        .disposed(by: disposeBag)
    }
    private func setSwitch(){
        Observable.of(false) //기본값인가? 기본값맞네
            .bind(to: rxSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        rxSwitch.rx.isOn
            //.skip(1) // 초기 상태 변경은 무시
            //.filter { $0 } 기본값에서 변경 된 값만 받아온다 즉, true만
            .map { isOn in // 타입을 바꿔준다!!!!!
                return isOn ? "On" : "Off"
            } // 값이 들어오면 출력
            .bind(to: Binder(self) { owner, message in // Binder -> orEmpty같은거?
                owner.switchLabel.text = "스위치 : \(message)"
            })
            .disposed(by: disposeBag)
    }
    private func setSign(){
        Observable.combineLatest(signName.rx.text.orEmpty,
                                 signEmail.rx.text.orEmpty) {
            value1, value2 in
            return "name은 \(value1)이고, 이메일은 \(value2)입니다."
        }
        .bind(to: textFieldLabel.rx.text)
        .disposed(by: disposeBag)
        
        signName.rx.text.orEmpty
            .map {$0.count < 4}
            .bind(to: signEmail.rx.isHidden, signButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        signEmail.rx.text.orEmpty
            .map {$0.count > 4}
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        signButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.showAlert(title: "알림", message: "저장!")
                print("ddd")
            }
            .disposed(by: disposeBag)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okButton)
        
        present(alertController, animated: true, completion: nil)
    }
    private func configureView(){
        view.backgroundColor = .white
        signButton.setTitle("나는 버튼", for: .normal)
        [pickerLabel, tableView, tableView, tableLabel, switchLabel, signName ,signEmail, textFieldLabel, signButton].forEach {
            $0.backgroundColor = .lightGray
        }
        [ pickerView, pickerLabel, tableView, tableLabel, rxSwitch, switchLabel, signName, signEmail, textFieldLabel, signButton]
            .forEach(view.addSubview)
    }
    private func configureLayout(){
        pickerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        pickerLabel.snp.makeConstraints { make in
            make.top.equalTo(pickerView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(pickerLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(100)
        }
        tableLabel.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        rxSwitch.snp.makeConstraints { make in
            make.top.equalTo(tableLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(30)
        }
        switchLabel.snp.makeConstraints { make in
            make.top.equalTo(rxSwitch.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(100)
            make.height.equalTo(44)
        }
        signName.snp.makeConstraints { make in
            make.top.equalTo(switchLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        signEmail.snp.makeConstraints { make in
            make.top.equalTo(signName.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        textFieldLabel.snp.makeConstraints { make in
            make.top.equalTo(signEmail.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        signButton.snp.makeConstraints { make in
            make.top.equalTo(textFieldLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
    }
}

