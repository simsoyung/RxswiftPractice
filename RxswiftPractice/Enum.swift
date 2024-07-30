//
//  Enum.swift
//  RxswiftPractice
//
//  Created by 심소영 on 7/30/24.
//

import UIKit

enum TextInput {
    enum PickerView: String, CaseIterable {
        case movie = "영화"
        case ani = "애니메이션"
        case drama = "드라마"
        case etc = "기타"
    }
    enum TableView: String, CaseIterable {
        case first = "첫번째"
        case second = "두번째"
        case third = "세번째"
    }
}


