//
//  SimpleValidation.swift
//  RxswiftPractice
//
//  Created by 심소영 on 7/31/24.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit

private let minimalUsernameLength = 5
private let minimalPasswordLength = 5

class SimpleValidation : UIViewController {

    private var userName = UITextField()
    private var userNameLabel = UILabel()
    
    private var password = UITextField()
    private var passwordLabel = UILabel()
    
    private var button = UIButton()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        userNameLabel.text = "이름은 \(minimalUsernameLength)자 이상이어야 합니다"
        passwordLabel.text = "비밀본호는 \(minimalPasswordLength)자 이상이어야 합니다"

        let usernameValid = userName.rx.text.orEmpty
            .map { $0.count >= minimalUsernameLength }
            .share(replay: 1)

        let passwordValid = password.rx.text.orEmpty
            .map { $0.count >= minimalPasswordLength }
            .share(replay: 1)

        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .share(replay: 1)

        usernameValid
            .bind(to: password.rx.isEnabled)
            .disposed(by: disposeBag)

        usernameValid
            .bind(to: userNameLabel.rx.isHidden)
            .disposed(by: disposeBag)

        passwordValid
            .bind(to: passwordLabel.rx.isHidden)
            .disposed(by: disposeBag)

        everythingValid
            .bind(to: button.rx.isEnabled)
            .disposed(by: disposeBag)

        button.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.showAlert() })
            .disposed(by: disposeBag)
    }
    private func configureView(){
        view.backgroundColor = .white
        [userName, userNameLabel, password, passwordLabel, button]
            .forEach(view.addSubview)
        [userName, userNameLabel, password, passwordLabel, button].forEach {
            $0.backgroundColor = .lightGray
        }
        userName.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(userName.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        password.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(password.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        button.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
    }
    func showAlert() {
        let alert = UIAlertController(
            title: "알림",
            message: "저장되었습니다",
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(title: "Ok",
                                          style: .default,
                                          handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}
