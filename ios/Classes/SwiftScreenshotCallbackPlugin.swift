import Flutter
import UIKit

public class SwiftScreenshotCallbackPlugin: NSObject, FlutterPlugin {
  static var channel: FlutterMethodChannel?
    
  static var observer: NSObjectProtocol?;
  static var recordingObserver: NSObjectProtocol?;


  public static func register(with registrar: FlutterPluginRegistrar) {
    channel  = FlutterMethodChannel(name: "flutter.moum/screenshot_callback", binaryMessenger: registrar.messenger())
    observer = nil;
    recordingObserver = nil;
    let instance = SwiftScreenshotCallbackPlugin()
    if let channel = channel {
      registrar.addMethodCallDelegate(instance, channel: channel)
    }
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if(call.method == "initialize"){
        if(SwiftScreenshotCallbackPlugin.observer != nil) {
            NotificationCenter.default.removeObserver(SwiftScreenshotCallbackPlugin.observer!);
            SwiftScreenshotCallbackPlugin.observer = nil;
        }
        if(SwiftScreenshotCallbackPlugin.recordingObserver != nil) {
            NotificationCenter.default.removeObserver(SwiftScreenshotCallbackPlugin.recordingObserver!);
            SwiftScreenshotCallbackPlugin.recordingObserver = nil;
        }
        SwiftScreenshotCallbackPlugin.observer = NotificationCenter.default.addObserver(
          forName: UIApplication.userDidTakeScreenshotNotification,
          object: nil,
          queue: .main) { notification in
          if let channel = SwiftScreenshotCallbackPlugin.channel {
            channel.invokeMethod("onCallback", arguments: nil)
          }
          result("screen shot called")
        }
        SwiftScreenshotCallbackPlugin.recordingObserver = NotificationCenter.default.addObserver(
          forName: UIScreen.capturedDidChangeNotification,
          object: nil,
          queue: .main) { notification in
          if let channel = SwiftScreenshotCallbackPlugin.channel {
            channel.invokeMethod("onCallback", arguments: nil)
          }
          result("screen recording turned on")
        }
      result("initialize")
    } else if(call.method == "dispose"){
        if(SwiftScreenshotCallbackPlugin.observer != nil) {
            NotificationCenter.default.removeObserver(SwiftScreenshotCallbackPlugin.observer!);
            SwiftScreenshotCallbackPlugin.observer = nil;
        }
        if(SwiftScreenshotCallbackPlugin.recordingObserver != nil) {
            NotificationCenter.default.removeObserver(SwiftScreenshotCallbackPlugin.recordingObserver!);
            SwiftScreenshotCallbackPlugin.recordingObserver = nil;
        }
        result("dispose")
    }else{
      result("")
    }
  }
    
    deinit {
        if(SwiftScreenshotCallbackPlugin.observer != nil) {
            NotificationCenter.default.removeObserver(SwiftScreenshotCallbackPlugin.observer!);
            SwiftScreenshotCallbackPlugin.observer = nil;
        }
        if(SwiftScreenshotCallbackPlugin.recordingObserver != nil) {
            NotificationCenter.default.removeObserver(SwiftScreenshotCallbackPlugin.recordingObserver!);
            SwiftScreenshotCallbackPlugin.recordingObserver = nil;
        }
    }
}
