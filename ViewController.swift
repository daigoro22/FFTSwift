//
//  ViewController.swift
//  FFT
//
//  Created by Abe Daigorou on 2016/04/17.
//  Copyright (c) 2016年 Abe Daigorou. All rights reserved.
//

import Cocoa
import Darwin

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        textfield.stringValue="こんにちは"
        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func pushed(sender: AnyObject) {
        let alert=NSAlert()
        alert.messageText="オサレ"
        alert.informativeText=textfield.stringValue
        alert.runModal()
        println(textfield.stringValue)
        /*var data:[Double]=[0,M_PI/4,M_PI/2,3*M_PI/4,M_PI,3*M_PI/4,M_PI/2,M_PI/4]*/
        
        var data=[Double](count:4096,repeatedValue:0)
        let f:Double=500
        let smpf:Double=1000
        for n:Int in 0...(data.count-1)/2
        {
            let d=Double(2*n)
            data[n]=sin(Double(1/smpf)*M_PI*f*d)
        }
        
        var fft=FFT(data: data,smpf: Int(smpf))
        let datas=fft.getFFTData()()
        println((smpf/Double(data.count))*Double(maxKey(datas)))
        
    }
    @IBOutlet weak var button: NSButton!
    @IBOutlet weak var textfield: NSTextField!
    
    private func maxKey(data:[Int16:Double])->Int16
    {
        var maxValue:Double=0
        var maxKey:Int16=0
        for (key,value) in data
        {
            if(maxValue<value&&key<Int16(data.count/2)){
                maxValue=value
                maxKey=key
            }
         println(maxKey)
        }
        return maxKey
    }
}

