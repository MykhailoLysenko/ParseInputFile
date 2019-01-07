//
//  ViewController.swift
//  ParseInputFile
//
//  Created by Mykhailo Lysenko on 1/7/19.
//  Copyright © 2019 Mykhailo Lysenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    typealias ItemInfo = [String: String]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchInfo()
    }
    
    func fetchInfo() {
        guard let path = Bundle.main.path(forResource: "TestPlist2", ofType: "m3u") else { return }
        do {
            if let infoArray = try parseInputFile(path) {
                print(infoArray)
            }
        } catch {
            print(error)
        }
    }
    
    func parseInputFile(_ path: String) throws -> [ItemInfo]? {
        var infoArray = [ItemInfo]()
        
        do {
            let fileText = try String(contentsOfFile: path, encoding: .utf8)
            let strings = fileText.components(separatedBy: .newlines)
                .filter({$0.hasPrefix("#EXTINF:")})
            var usefulTagStrings = [String]()
            
            for item in strings {
                if let usefuleComponent = item.components(separatedBy: ",")
                    .first(where: {$0.contains("=")}) {
                    usefulTagStrings.append(usefuleComponent)
                }
            }
            
            for item in usefulTagStrings {
                var itemInfo = ItemInfo()
                item.components(separatedBy: .whitespaces)
                    .reduce("", { $0 + ($1.contains("=") ? "\n" : " ") + $1 })
                    .components(separatedBy: .newlines)
                    .filter({ !$0.isEmpty })
                    .map({ $0.components(separatedBy: "=") })
                    .filter({ $0.count > 1 })
                    .forEach({ itemInfo[$0.first!] = $0.last! })
                infoArray.append(itemInfo)
            }
        } catch {
            print(error)
        }
        
        return infoArray
    }
}

