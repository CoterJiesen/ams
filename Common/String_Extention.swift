//
//  File.swift
//  ams
//
//  Created by yangyuan on 2017/8/15.
//  Copyright © 2017年 coterjiesen. All rights reserved.
//

extension String
{
    func ck_compare(with version: String) -> ComparisonResult {
        return compare(version, options: .numeric, range: nil, locale: nil)
    }
    
    func isNewer(than aVersionString: String) -> Bool {
        return ck_compare(with: aVersionString) == .orderedDescending
    }
    
    func isOlder(than aVersionString: String) -> Bool {
        return ck_compare(with: aVersionString) == .orderedAscending
    }
    
    func isSame(to aVersionString: String) -> Bool {
        return ck_compare(with: aVersionString) == .orderedSame
    }
}

