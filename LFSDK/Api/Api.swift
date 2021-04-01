//
//  Api.swift
//  ymsports
//
//  Created by wood on 25/1/21.
//

import Alamofire
import CommonCrypto
import CoreTelephony
import Foundation
import HandyJSON

/// 通过泛型转模型统一输出，兼容多版本API
public class ApiModel<T: HandyJSON>: HandyJSON {
    /// 状态码
    public var code: Int = 0

    /// 错误信息
    public var msg: String = ""

    /// 返回原始数据
    public var data: Any?

    /// 返回转模型后的对象
    public var object: T?

    /// 返回转模型后的对象数组
    public var array: [T]?

    private var status: Bool?

    /// 是否成功请求到数据
    public var isSuccess: Bool { return self.code == Api.kSuccess }

    public required init() { }

    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            status <-- "status"
        mapper <<<
            code <-- "code"
        mapper <<<
            msg <-- "msg"
        mapper <<<
            data <-- "data"
    }

    public func didFinishMapping() {
        if let status = status {
            code = status ? 0 : -1
            if !status {
                msg = "\(data ?? "")"
            }
        }
    }

    init(error: Api.Error) {
        code = error.rawValue
        switch error {
        case .noNetwork:
            msg = "error_network".sdkLocalized()
        case .timeout:
            msg = "error_request_timeout".sdkLocalized()
        default:
            msg = "error_server_error".sdkLocalized()
        }
    }
}

/// Api接口层，提供不同的接口服务
public class Api {
    /// 请求失败错误类型
    ///
    /// - noNetwork: 无网络
    /// - timeout: 请求超时
    /// - dataError: 解析数据失败
    /// - serverError: 服务器错误，responseCode != 200
    enum Error: Int {
        case noNetwork = -1
        case timeout = -2
        case dataError = -3
        case serverError = -4
    }

    /// 请求时是否显示loading
    ///
    /// - none: 不显示（默认选项）
    /// - selfView: 显示在当前控制器view上，loading不会全屏覆盖（推荐）
    /// - keyWindow: 顶级window上，如果请求事件过长用户无法操作（不建议）
    /// - some(View): 在指定的view中显示loading
    public enum Loading<View> {
        /// 不显示（默认选项）
        case none
        /// 显示在当前控制器view上，loading不会全屏覆盖（推荐）
        case selfView
        /// 顶级window上，如果请求事件过长用户无法操作（不建议）
        case keyWindow
        /// 在指定的view中显示loading
        case some(View)
    }

    /// 接口成功码
    public static let kSuccess: Int = 0
    public static let apiVersion = "1.0.0"

    static let acceptableContentTypes = ["application/json", "text/json", "text/plain"] // text/plain用来支持Charles Local Map

    static let `default`: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.HTTPHeaders.default.dictionary
        configuration.timeoutIntervalForRequest = 25
        var serverTrustPolicies: [String: ServerTrustEvaluating] = [:]
        /**
         SSL安全认证：与服务器建立安全连接需要对服务器进行验证，可以用证书或者公钥私钥来实现
         该网络框架支持的证书类型：[".cer", ".CER", ".crt", ".CRT", ".der", ".DER"]
         1、DefaultTrustEvaluator 默认策略
         2、SSL Pinning阻止中间人Charles攻击
            - PinnedCertificatesTrustEvaluator 内置证书，将证书放入app的bundle里
            - PublicKeysTrustEvaluator 内置公钥，将证书的公钥硬编码进代码里
         3、DisabledEvaluator 不验证
         然并卵 - 我们公司的网络连接并没有SSL安全认证，强烈吐槽
         */
        // TODO:认证不通过，暂时去掉
//        ["api.xxx.com"].compactMap{ HttpDnsService.sharedInstance()?.getIpByHostAsync($0) }.forEach{ serverTrustPolicies[$0] = DisabledEvaluator() }
//        return Alamofire.Session(configuration: configuration, serverTrustManager: ServerTrustManager(evaluators: serverTrustPolicies))
        return Alamofire.Session(configuration: configuration)
    }()

    /// 带模型转换的网络请求，模型是对象Object
    ///
    /// - Parameters:
    ///   - urlRequest: 自定义请求对象
    /// - Returns: DataRequest，无网络时不执行请求返回nil
    @discardableResult
    public class func request(_ urlRequest: URLRequestConvertible) -> DataRequest? {
        if let isReachable = NetworkReachabilityManager()?.isReachable, !isReachable {
            if let keyWindow = UIApplication.shared.keyWindow {
                ToastUtil.showMessage("error_network".sdkLocalized(), inView: keyWindow)
            }
            return nil
        }
        return Api.default.request(urlRequest).validate(statusCode: [200])
    }

    /// 带模型转换的网络请求，模型是对象Object
    ///
    /// - Parameters:
    ///   - urlRequest: 自定义请求对象
    ///   - keyPath: 对象路径keyPath，是从data后面key开始算起的
    ///   - loading: 是否显示loading
    ///   - completionHandler: 完成回调
    /// - Returns: DataRequest，无网络时不执行请求返回nil
    @discardableResult
    public class func request<T: HandyJSON>(_ urlRequest: URLRequestConvertible,
                                            keyPath: String? = nil,
                                            loading: Loading<UIView> = .none,
                                            completionHandler: @escaping(_ result: ApiModel<T>) -> Void) -> DataRequest? {
        if let isReachable = NetworkReachabilityManager()?.isReachable, !isReachable {
            if let keyWindow = UIApplication.shared.keyWindow {
                ToastUtil.showMessage("error_network".sdkLocalized(), inView: keyWindow)
            }
            return nil
        }
        var loadingView: UIView?
        DispatchQueue.main.async {
            switch loading {
            case .keyWindow:
                loadingView = UIApplication.shared.keyWindow
            case .selfView:
                loadingView = UIApplication.topViewController?.view
            case .some(let view):
            loadingView = view
            default:
                break
            }
            if let loadingView = loadingView {
                ToastUtil.showLoading(in: loadingView)
            }
        }
        return Api.default.request(urlRequest).validate(statusCode: [200]).validate(contentType: acceptableContentTypes).responseJSON { response in
            switch response.result {
            case .success(let value):
                XLog("😂😂\(String(describing: response.metrics)) \(String(describing: urlRequest.urlRequest)) \(value)")
                var result = ApiModel<T>(error: .dataError)
                if let value = value as? [String: Any] {
                    var wrapperValue: [String: Any] = ["code": 0, "msg": "success", "data": value]
                    if value.keys.contains("data") { // 普通数据
                        wrapperValue = value
                    } else if value.keys.contains("StatusCode") && value.keys.contains("StatusDesc") { // IM Sports
                        let statusCode = value["StatusCode"] as? Int ?? 0
                        let statusDesc = value["StatusDesc"] as? String ?? "success"
                        wrapperValue["code"] = statusCode == 100 ? 0 : statusCode
                        wrapperValue["msg"] = statusDesc
                    }
                    if let model = ApiModel<T>.deserialize(from: wrapperValue) {
                        model.object = T.deserialize(from: model.data as? [String: Any], designatedPath: keyPath)
                        if model.object == nil, let jsonObj = model.data,
                           let data = try? JSONSerialization.data(withJSONObject: jsonObj, options: .fragmentsAllowed),
                           let string = String(data: data, encoding: .utf8) {
                            model.array = [T].deserialize(from: string, designatedPath: keyPath)?.compactMap({ $0 })
                        }
                        result = model
                    }
                }
                DispatchQueue.main.async { completionHandler(result) }
            case .failure(let error):
                XLog("😞😞\(String(describing: response.metrics)) \(String(describing: urlRequest.urlRequest)) \(error.localizedDescription)")
                let result = ApiModel<T>(error: (error as NSError).code == NSURLErrorTimedOut ? .timeout : .serverError)
                DispatchQueue.main.async { completionHandler(result) }
            }
            DispatchQueue.main.async {
                if let loadingView = loadingView {
                    ToastUtil.hide(in: loadingView)
                }
            }
        }
    }

    /// 带模型转换和Header的网络请求，模型是对象Object
    ///
    /// - Parameters:
    ///   - urlRequest: 自定义请求对象
    ///   - keyPath: 对象路径keyPath，是从data后面key开始算起的
    ///   - loading: 是否显示loading
    ///   - completionHandler: 完成回调
    /// - Returns: DataRequest，无网络时不执行请求返回nil
    @discardableResult
    public class func request<T: HandyJSON>(_ urlRequest: URLRequestConvertible,
                                            keyPath: String? = nil,
                                            loading: Loading<UIView> = .none,
                                            completionHandler: @escaping(_ result: ApiModel<T>, _ header: HTTPHeaders?) -> Void) -> DataRequest? {
        if let isReachable = NetworkReachabilityManager()?.isReachable, !isReachable {
            if let keyWindow = UIApplication.shared.keyWindow {
                ToastUtil.showMessage("error_network".sdkLocalized(), inView: keyWindow)
            }
            return nil
        }
        var loadingView: UIView?
        DispatchQueue.main.async {
            switch loading {
            case .keyWindow:
                loadingView = UIApplication.shared.keyWindow
            case .selfView:
                loadingView = UIApplication.topViewController?.view
            case .some(let view):
            loadingView = view
            default:
                break
            }
            if let loadingView = loadingView {
                ToastUtil.showLoading(in: loadingView)
            }
        }
        return Api.default.request(urlRequest).validate(statusCode: [200]).validate(contentType: acceptableContentTypes).responseJSON { response in
            switch response.result {
            case .success(let value):
                XLog("😂😂\(String(describing: response.metrics)) \(String(describing: urlRequest.urlRequest)) \(value)")
                var result = ApiModel<T>(error: .dataError)
                if let value = value as? [String: Any] {
                    var wrapperValue: [String: Any] = ["code": 0, "msg": "success", "data": value]
                    if value.keys.contains("data") { // 普通数据
                        wrapperValue = value
                    } else if value.keys.contains("StatusCode") && value.keys.contains("StatusDesc") { // IM Sports
                        let statusCode = value["StatusCode"] as? Int ?? 0
                        let statusDesc = value["StatusDesc"] as? String ?? "success"
                        wrapperValue["code"] = statusCode == 100 ? 0 : statusCode
                        wrapperValue["msg"] = statusDesc
                    }
                    if let model = ApiModel<T>.deserialize(from: wrapperValue) {
                        model.object = T.deserialize(from: model.data as? [String: Any], designatedPath: keyPath)
                        if model.object == nil, let jsonObj = model.data,
                           let data = try? JSONSerialization.data(withJSONObject: jsonObj, options: .fragmentsAllowed),
                           let string = String(data: data, encoding: .utf8) {
                            model.array = [T].deserialize(from: string, designatedPath: keyPath)?.compactMap({ $0 })
                        }
                        result = model
                    }
                }
                DispatchQueue.main.async { completionHandler(result, response.response?.headers) }
            case .failure(let error):
                XLog("😞😞\(String(describing: response.metrics)) \(String(describing: urlRequest.urlRequest)) \(error.localizedDescription)")
                let result = ApiModel<T>(error: (error as NSError).code == NSURLErrorTimedOut ? .timeout : .serverError)
                DispatchQueue.main.async { completionHandler(result, nil) }
            }
            DispatchQueue.main.async {
                if let loadingView = loadingView {
                    ToastUtil.hide(in: loadingView)
                }
            }
        }
    }
}
