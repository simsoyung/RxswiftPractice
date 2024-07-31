//
//  AddingNumbers.swift
//  RxswiftPractice
//
//  Created by 심소영 on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
 
class AddingNumbers: UIViewController {
    
    let disposeBag = DisposeBag()
    
    private var number1 = UITextField()
    private var number2 = UITextField()
    private var number3 = UITextField()

    private var result = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        Observable.combineLatest(number1.rx.text.orEmpty, number2.rx.text.orEmpty, number3.rx.text.orEmpty) { num1, num2, num3 -> Int in
            return (Int(num1) ?? 0) + (Int(num2) ?? 0) + (Int(num3) ?? 0)
        }
        .map { $0.description }
        .bind(to: result.rx.text)
        .disposed(by: disposeBag)
    }
    private func configureView(){
        view.backgroundColor = .white
        [number1, number2, number3, result]
            .forEach(view.addSubview)
        [number1, number2, number3, result].forEach {
            $0.backgroundColor = .lightGray
        }
        number1.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        number2.snp.makeConstraints { make in
            make.top.equalTo(number1.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        number3.snp.makeConstraints { make in
            make.top.equalTo(number2.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        result.snp.makeConstraints { make in
            make.top.equalTo(number3.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
    }
}
