//
//  Constant.swift
//
//

import Foundation
import UIKit

let MainScreen = UIScreen.main.bounds.size

let appDelegate     = UIApplication.shared.delegate as! AppDelegate
let userDefaults    = UserDefaults.standard
let Alert_NoInternet    = "You are not connected to internet.\nPlease check your internet connection."
let Alert_NoDataFound    = "No Data Found."


let kkeydata = "data"
let kkeymessage = "message"
let kNO = "NO"
let kYES = "YES"

//let kGOOGLEAPIKEY = "AIzaSyCQsja54oBXysiyM6Xc4NAFtpGYL6i-1es"
let googleKey = "AIzaSyBjj1HuwALfX9Ye3OiM-nWvqz1hhU4hoQE"
var progressView : UIView?
var appUtilities: AppUtilities!

