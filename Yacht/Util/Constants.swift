//
//  Constants.swift
//  Yacht
//
//  Created by Henry Minden on 8/24/22.
//

import Foundation
import UIKit

struct Constants {
 
    struct Colors {
        
        static let viewBackgroundColor = UIColor(red: 255/255, green: 254/255, blue: 250/255, alpha: 255/255)
        static let primaryColor = UIColor(red: 38/255, green: 18/255, blue: 1/255, alpha: 255/255)
        static let secondaryColor = UIColor(red: 175/255, green: 203/255, blue: 255/255, alpha: 255/255)
        static let tertiaryColor = UIColor(red: 215/255, green: 249/255, blue: 255/255, alpha: 255/255)
        static let viewHighlightColor = UIColor(red: 255/255, green: 237/255, blue: 225/255, alpha: 255/255)
        
        static let lightYellow = UIColor(red: 251/255, green: 197/255, blue: 117/255, alpha: 255/255)
        static let lightGray = UIColor(red: 170/255, green: 183/255, blue: 191/255, alpha: 255/255)
        static let mediumRed = UIColor(red: 173/255, green: 29/255, blue: 29/255, alpha: 255/255)
        static let oliveDrab = UIColor(red: 115/255, green: 99/255, blue: 86/255, alpha: 255/255)
        static let deepRed = UIColor(red: 38/255, green: 18/255, blue: 1/255, alpha: 255/255)
        static let parchment = UIColor(red: 252/255, green: 251/255, blue: 238/255, alpha: 255/255)
        
    }
    
    struct LocalStorage {
        static let chainId = "chainId"
    }
    
    static let evmChainNames: [(Int,String)] = [
        (1,"Ethereum Mainnet"),
        (3, "Ropsten"),
        (5, "Goerli"),
        (11155111, "Sepolia")
    ]
    
    static let tokenImage: [String:String] = [
        "0x6b175474e89094c44da98b954eedeac495271d0f":"https://i.imgur.com/vzlX0HQ.png", // DAI
        "0x2260fac5e5542a773aa44fbcfedf7c193bc2c599":"https://i.imgur.com/5jpMTcv.png", // wBTC
        "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2":"https://i.imgur.com/gWiAy8c.png", // wETH
        "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984":"https://i.imgur.com/novMdtQ.png", // UNI
        "0x514910771af9ca656af840dff83e8264ecf986ca":"https://i.imgur.com/a1YNkqT.png", // LINK
        "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48":"https://i.imgur.com/LTKb2wq.png", // USDC
        "0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0":"https://i.imgur.com/ifi5qRp.png", // wstETH
    ]

}
