//
//  String+Extension.swift
//  ShoesPlease
//
//  Created by YoungK on 2022/08/06.
//

import Foundation

extension String {
  func sliceFrom(start: String, to: String) -> String? {
    guard let s = rangeOfString(start)?.endIndex else { return nil }
    guard let e = rangeOfString(to, range: s..<endIndex)?.startIndex else { return nil }
    return self[s..<e]
  }
}
