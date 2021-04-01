//
//  FoundationExtension.swift
//  ymsports
//
//  Created by wood on 3/3/21.
//

import UIKit
import CommonCrypto

/// 日志输出，正式环境会去掉不占用资源
///
/// - Parameters:
///   - message: 需要打印的内容
///   - file: 所在文件
///   - line: 行号
///   - method: 方法名
public func XLog(_ item: Any, file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    print("\(file.components(separatedBy: "/").last ?? file) \(function) \(line): \(item)")
    #else

    #endif
}

public extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            XLog("html2AttributedString error:\(error.localizedDescription)")
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

// MARK: - BinaryFloatingPoint
public extension BinaryFloatingPoint {
    /// 小数点后如果只是0，显示整数，如果不是，显示原来的值
    var cleanZero: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self as! CVarArg) : "\(self)"
    }
}

public extension NSObject {
    var className: String {
        get {
            return type(of: self).description()
        }
    }
}

public extension DateFormatter {
    static let formatter = DateFormatter()
}

public extension Date {
    func strValue(dateFormat:String = "yy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 8 * 60 * 60)! //TimeZone(identifier: "EST")
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let dateStr = formatter.string(from: self)
        return dateStr
    }
}

// MARK: - Double
public extension Double {

    /// 根据时间戳获取和格式获取对应的时间字符串
    ///
    /// - Parameter format: 日期格式化 yyyy-MM-dd HH:mm:ss
    /// - Returns: 2018-06-01 12:12:00
    func timeString(_ format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        DateFormatter.formatter.timeZone = TimeZone(secondsFromGMT: 8 * 60 * 60)
        DateFormatter.formatter.dateFormat = format
        return DateFormatter.formatter.string(from: Date(timeIntervalSince1970: self))
    }
}

// MARK: - String
public extension String {

    /// 判断是否是有效的URL字符串
    ///
    /// - Returns: true/false
    func isValidURL() -> Bool {
        if let url = URL(string: self), let _ = url.scheme, let _ = url.host {
            return true
        }
        return false
    }

    /// 获取URL路径中的参数
    ///
    /// - Returns: 参数map
    func getURLParams() -> [String: String] {
        var map: [String: String] = [:]
        if let range = self.range(of: "?") {
            self.suffix(from: range.upperBound).split(separator: "&").forEach({
                let array = $0.split(separator: "=")
                if let key = array.first, let value = array.last, !key.isEmpty {
                    map[String(key)] = String(value)
                }
            })
        }
        return map
    }

    /// 查询字符串编码
    ///
    /// - Returns: urlEncode string
    func urlEncode() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }

    /// 正则表达式匹配，能匹配到就返回true否则false
    ///
    /// - Parameters:
    ///   - regex: 正则表达式
    ///   - options: 匹配规则
    /// - Returns: true/false
    func matches(regex: String, options: NSRegularExpression.Options) -> Bool {
        if let pattern = try? NSRegularExpression(pattern: regex, options: options) {
            return (pattern.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: self.count)) > 0)
        } else {
            return false
        }
    }

    /// 正则表达式替换文本
    ///
    /// - Parameters:
    ///   - regex: 正则表达式
    ///   - options: 匹配规则
    ///   - replacement: 替换文本
    /// - Returns: 替换后的文本
    func stringByReplacing(regex: String, options: NSRegularExpression.Options, replacement: String) -> String {
        if let pattern = try? NSRegularExpression(pattern: regex, options: options) {
            return pattern.stringByReplacingMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: self.count), withTemplate: replacement)
        } else {
            return self
        }
    }

    /// 如可以转换就转换链接，否则返回原字符串，不针对图片链接处理。图片链接转换参考imageURLString()
    ///
    /// - Returns: 链接/原字符串
    func URLString() -> String {
        var result: String = self
        if self.hasPrefix("//") {
            result = "http:" + self
        }
        return result
    }

    /// 图片链接转换
    ///
    /// - Returns: 图片链接/原字符串
    func imageURLString() -> String {
        var result: String = self
        if self.hasPrefix("//") {
            result = self.URLString()
        }
        if self.hasSuffix("_.webp") {
            result = String(result.prefix(result.count - 6))
        }
        return result
    }

    /// 正则表达式替换
    ///
    /// - Parameters:
    ///   - regex: 正则表达式
    ///   - replacement: 替换为字符
    /// - Returns: 替换后的字符
    func replacing(regex: String, with replacement: String) -> String {
        if let pattern = try? NSRegularExpression(pattern: regex, options: .caseInsensitive) {
            return pattern.stringByReplacingMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: self.count), withTemplate: replacement)
        } else {
            return self
        }
    }

    /// 获取文本中的链接
    ///
    /// - Returns: 链接数组，未匹配到返回[]
    func getLinks() -> [String] {
        var links: [String] = []
        if let pattern = try? NSRegularExpression(pattern: "[a-zA-z]+://[^\\s]*", options: .caseInsensitive) {
            let results = pattern.matches(in: self, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSRange(location: 0, length: self.count))
            for text in results {
                for idx in 0..<text.numberOfRanges {
                    let range = text.range(at: idx)
                    if let url = (self as NSString).substring(with: range).urlEncode() {
                        XLog("range=\(range) link:\(url)")
                        links.append(url)
                    }
                }
            }
        }
        return links
    }

    /// 获取HTML中的img标签和src内容
    ///
    /// - Returns: 返回元祖 (img标签数组, img的src属性数组)
    func getLinksFromImgTag() -> (sources: [String], links: [String]) {
        // bug:😏遇到表情字符会解析出问题，➕" "解决
        let originString = " \(self) "
        let regexImgSrc = "<img[^>]+src\\s*=\\s*['\"]([^'\"]+)['\"][^>]*>"
        var sources: [String] = []
        var links: [String] = []
        if let pattern = try? NSRegularExpression(pattern: regexImgSrc, options: .caseInsensitive) {
            let results = pattern.matches(in: originString, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: originString.count))
            for text in results {
                for idx in 0..<text.numberOfRanges {
                    let url = (originString as NSString).substring(with: text.range(at: idx))
                    idx % 2 == 0 ? sources.append(url) : links.append(url)
                }
            }
        }
        return (sources, links)
    }

    /// 获取HTML中的a标签和src内容
    ///
    /// - Returns: 返回元祖 (a标签数组, a的src属性数组)
    func getLinksFromATag() -> (sources: [String], links: [String]) {
        let originString = " \(self) "
        let regexImgSrc = "<a[^>]+href\\s*=\\s*['\"]([^'\"]+)['\"][^>]*>"
        var sources: [String] = []
        var links: [String] = []
        if let pattern = try? NSRegularExpression(pattern: regexImgSrc, options: .caseInsensitive) {
            let results = pattern.matches(in: originString, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: originString.count))
            for text in results {
                for idx in 0..<text.numberOfRanges {
                    let url = (originString as NSString).substring(with: text.range(at: idx))
                    idx % 2 == 0 ? sources.append(url) : links.append(url)
                }
            }
        }
        return (sources, links)
    }

    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }

    /// range转换为NSRange
    func nsRange(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }

    /// NSRange转化为range
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
    
    ///截取字符串
    subscript(loc: Int) -> String {
         let startIndex = self.index(self.startIndex, offsetBy: loc)
        return String(self[startIndex..<self.endIndex])
    }
    
    ///截取字符串
    subscript(loc: Int, lenth: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: loc)
        let endIndex = self.index(self.startIndex, offsetBy: loc + lenth)
        return String(self[startIndex..<endIndex])
    }

    /// 根据字体和宽度计算文本高度，如果是富文本属性请用自带的api实现
    ///
    /// - Parameters:
    ///   - width: 宽度
    ///   - font: 字体
    /// - Returns: 文本高度
    func boundingHeight(width: CGFloat, font: UIFont) -> CGFloat {
        return self.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: font], context: nil).size.height
    }

}

extension String {
    /// 获取字符串MD5值
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize(count: digestLen)
        return String(format: hash as String)
    }
    
    /// String sha1
    func sha1() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}


// MARK: - Collection
public extension Collection {
    /// 集合元素下标安全访问，越界返回nil
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
