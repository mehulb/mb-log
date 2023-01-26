//
//  ViewController.swift
//  MBLogExample-macos
//
//  Created by Mehul Bhavani on 20/01/23.
//

import Cocoa
import MBLog

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var config = MBLog.Config()
        if let name = Bundle.main.bundleIdentifier {
            config.moduleName = name
        }
        config.shouldWriteToFile = true
        config.shouldLogContext = true
        config.logLevel = MBLog.LogLevel.debug
        config.datetimeFormat = "yy:MM:dd'⏱️'HH:mm:ss"
        
        MBLog.setConfig(config)
        
        MBLog.logEnvironment()

        MBLog.debug("This is 'debug' message")
        MBLog.info("This is 'info' message")
        MBLog.success("This is 'success' message")
        MBLog.failure("This is 'failure' message")
        MBLog.warning("This is 'warning' message")
        MBLog.error("This is 'error' message")
        
        config.delimiter = .pipe
        MBLog.setConfig(config)
        MBLog.error("This is with 'pipe'")
        
        config.delimiter = .parentheses
        MBLog.setConfig(config)
        MBLog.error("This is with 'parentheses'")
        
        config.delimiter = .brackets
        MBLog.setConfig(config)
        MBLog.error("This is with 'brackets'")
        
        config.delimiter = .braces
        MBLog.setConfig(config)
        MBLog.error("This is with 'braces'")
        
        config.delimiter = .chevrons
        MBLog.setConfig(config)
        MBLog.error("This is with 'chevrons'")
        
        config.delimiter = .period
        MBLog.setConfig(config)
        MBLog.error("This is with 'period'")
        
        config.delimiter = .hiphen
        MBLog.setConfig(config)
        MBLog.error("This is with 'hiphen'")
        
        config.delimiter = .colon
        MBLog.setConfig(config)
        MBLog.error("This is with 'colon'")
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

