//
//  Reachability.swift
//  Commons Menu1
//
//  Created by Wu, Andrew on 7/10/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//


//http://www.brianjcoleman.com/tutorial-check-for-internet-connection-in-swift/
import Foundation
public class Reachability {
    
    

    class func isConnectedToNetwork()->Bool{
        
        var Status:Bool = false
        let url = NSURL(string: "http://baidu.com/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil) as NSData?
        
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                Status = true
            }
        }
        return Status
    }
}