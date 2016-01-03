//
//  PolymorphicScannerService.swift
//  POS
//
//  Created by Gal Blank on 12/15/15.
//  Copyright © 2015 1stPayGateway. All rights reserved.
//

import UIKit



class PolymorphicPrinterService: NSObject {
    
    func startService(){}
    
    func consumeMessage(notif:NSNotification){}
    
    func searchForAllConnectedPrinters(){}
    
    func printerDidConnect(notif:NSNotification){}
    
}
