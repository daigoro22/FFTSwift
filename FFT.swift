//
//  FFT.swift
//  FFT
//
//  Created by Abe Daigorou on 2016/04/17.
//  Copyright (c) 2016年 Abe Daigorou. All rights reserved.
//

import Foundation
import Cocoa
import Darwin

struct Complex{
    var Re:Double=0.0
    var Im:Double=0.0
    var stringValue:String{
        get{
            return "(\(Re),\(Im))"
        }
        set{
            
        }
    }
    
    var exp:Complex{
        get{
            if Re==0.0{
                return Complex(Re:cos(Im),Im:sin(Im))
            }
            else{
                return Complex(Re:0,Im:0)
            }
        }
    }
    
    var abs:Double{
        get{
            return sqrt((Re**2)+(Im**2))
        }
        set{
            
        }
    }
}

func +(lhs:Complex,rhs:Complex)->Complex
{
    return Complex(Re:lhs.Re+rhs.Re,Im:lhs.Im+rhs.Im)
}

func -(lhs:Complex,rhs:Complex)->Complex
{
    return Complex(Re:lhs.Re-rhs.Re,Im:lhs.Im-rhs.Im)
}

func *(lhs:Complex,rhs:Complex)->Complex
{
    return Complex(Re:lhs.Re*rhs.Re-lhs.Im*rhs.Im,
        Im:lhs.Re*rhs.Im+lhs.Im*rhs.Re)
}

func /(lhs:Complex,rhs:Complex)->Complex
{
    var child:Complex=lhs*rhs
    var mom:Double=(rhs.Re**2)+(rhs.Im**2)
    return Complex(Re:child.Re/mom,Im:child.Im/mom)
}

infix operator **{associativity left precedence 120}
func **(lhs:Double,rhs:Int)->Double
{
    var v:Double=1
    for n in 1...rhs
    {
        v*=lhs
    }
    return v
}

class FFT
{
    var data:[Complex]=[]
    var smpf:Int
    var length:Int
    
    init(data:[Double],smpf:Int)
    {
        self.length=data.count
        self.smpf=smpf
        for n in data
        {
            self.data.append(Complex(Re: Double(n), Im: 0.0))
        }
    }
    
    internal func getFFTData()->()->[Int16:Double]
    {
        var FFTData:[Int16:Double]=[:]
        var count:Int16=0
        var btf:((length:Int16,data:[Complex])-> Int)!
        btf={
            (length:Int16,data:[Complex])->Int in
            if !length.isEven
            {
                println("detaSize was wrong!")
                return 0
            }
            var halfLen:Int16=(length/2)
            var plusData:[Complex]=[]
            var minusData:[Complex]=[]
            
            for i:Int16 in 0...halfLen-1
            {
                plusData.append(data[i.i32]+data[(halfLen+i).i32])
                var twiddle=Complex(Re: 0, Im: -2*M_PI*Double(i)/Double(length))
                minusData.append(twiddle.exp*(data[i.i32]-data[(halfLen+i).i32]))
                if(length==2)
                {
                    FFTData[Int16(count++.reverse(self.data.count.bits-1))]=(plusData[0].abs)
                    FFTData[Int16(count++.reverse(self.data.count.bits-1))]=(minusData[0].abs)
                    
                    return 0
                }
            }
            btf(length:plusData.count.i16,data:plusData)
            btf(length:minusData.count.i16,data:minusData)
            return 0
        }
        
        return {
            ()->[Int16:Double] in
            btf(length:self.data.count.i16,data:self.data)
            return FFTData
        }
    }
}

extension Int16{
    var rev:Int16{return self}
    var i32:Int{return Int(self)}
    var isEven:Bool{
        if(self%2==0){
            return true
        }else{
            return false
        }
    }
    var bits:Int16{
        var count:Int16=0
        var temp:Int16=self
        while temp>1
        {
            temp/=2
            count++
        }
        return count
    }
    func reverse(bitNum:Int16)->UInt16
    {
        var rev:UInt16=0
        var tempInt=self
        var tempBit=bitNum
        
        while tempInt>0
        {
            rev+=UInt16((tempInt&1.i16)<<tempBit--)
            tempInt>>=1
        }
        return rev
    }
}

extension UInt{
    var i32:Int{return Int(self)}
}

extension Int{
    var i16:Int16{return Int16(self)}
    var bits:Int16{
        var count:Int=0
        var temp:Int=self
        while temp>1
        {
            temp/=2
            count++
        }
        return count.i16
    }
    
    internal func reverse(bitNum:Int)->Int
    {
        var rev:Int=0
        var tempInt=self
        var tempBit=bitNum
        
        while tempInt>0
        {
            rev+=Int((tempInt&1)<<tempBit--)
            tempInt>>=1
        }
        return rev
    }
}
