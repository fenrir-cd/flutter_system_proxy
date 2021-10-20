import Flutter
import UIKit

public class SwiftSystemProxyPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "system_proxy", binaryMessenger: registrar.messenger())
        let instance = SwiftSystemProxyPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "getProxySettings" {
            result(getProxySettings())
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func getProxySettings() -> String? {
        guard let settings = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() as? [String : Any],
              let host = settings[kCFNetworkProxiesHTTPProxy as String],
              let port = settings[kCFNetworkProxiesHTTPPort as String] else {
                  return nil
              }
        return "\(host):\(port)"
    }
}
