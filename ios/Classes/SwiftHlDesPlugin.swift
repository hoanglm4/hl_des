import Flutter
import UIKit
import CommonCrypto

public class SwiftHlDesPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "hl_des", binaryMessenger: registrar.messenger())
        let instance = SwiftHlDesPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let params = call.arguments as! Dictionary<String, Any>
        let key =  params["key"] as! String
        let iv = params["iv"] as! String
        let data = params["data"] as! String
        
        switch call.method {
        case "desEncrypt":
            result(data.desEncrypt(key: key, iv: iv))
        case "desDecrypt":
            result(data.desDecrypt(key: key, iv: iv))
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
}

extension String {
    
    func desEncrypt(key:String, iv:String, options:Int = kCCOptionPKCS7Padding) -> String? {
        
        if let data = self.data(using: String.Encoding.utf8),
           let btCryptKey = NSData(base64Encoded: key),
           let btInitializationVector = NSData(base64Encoded: iv),
           let cryptData    = NSMutableData(length: Int((data.count)) + kCCBlockSizeDES) {
            
            
            let keyLength              = size_t(kCCKeySizeDES)
            let operation: CCOperation = UInt32(kCCEncrypt)
            let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmDES)
            let options:   CCOptions   = UInt32(options)
            
            
            
            var numBytesEncrypted :size_t = 0
            
            let cryptStatus = CCCrypt(operation,
                                      algoritm,
                                      options,
                                      btCryptKey.bytes,
                                      keyLength,
                                      btInitializationVector.bytes,
                                      (data as NSData).bytes, data.count,
                                      cryptData.mutableBytes, cryptData.length,
                                      &numBytesEncrypted)
            
            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                cryptData.length = Int(numBytesEncrypted)
                let base64cryptString = cryptData.base64EncodedString(options: .lineLength64Characters)
                return base64cryptString
                
            }
            else {
                return nil
            }
        }
        return nil
    }
    
    func desDecrypt(key:String, iv:String, options:Int = kCCOptionPKCS7Padding) -> String? {
        
        if let data = NSData(base64Encoded: self, options: .ignoreUnknownCharacters),
           let btCryptKey = NSData(base64Encoded: key),
           let btInitializationVector = NSData(base64Encoded: iv),
           let cryptData    = NSMutableData(length: Int((data.length)) + kCCBlockSizeDES) {
            
            let keyLength              = size_t(kCCKeySizeDES)
            let operation: CCOperation = UInt32(kCCDecrypt)
            let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmDES)
            let options:   CCOptions   = UInt32(options)
            
            var numBytesEncrypted :size_t = 0
            
            let cryptStatus = CCCrypt(operation,
                                      algoritm,
                                      options,
                                      btCryptKey.bytes,
                                      keyLength,
                                      btInitializationVector.bytes,
                                      data.bytes, data.length,
                                      cryptData.mutableBytes, cryptData.length,
                                      &numBytesEncrypted)
            
            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                cryptData.length = Int(numBytesEncrypted)
                let unencryptedMessage = String(data: cryptData as Data, encoding:String.Encoding.utf8)
                return unencryptedMessage
            }
            else {
                return nil
            }
        }
        return nil
    }
}
