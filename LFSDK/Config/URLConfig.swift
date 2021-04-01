//
//  URLConfig.swift
//  ymsports
//
//  Created by wood on 25/1/21.
//
import Alamofire
import Foundation

/// URL Host 项目请求地址配置
///
/// - user: user api 全站项目
/// - game: Game api 盘口项目
public enum URLConfig {
    /// user api 全站项目
    case user
    /// 188盘口
    case game188
    /// IM盘口
    case gameIM

    /// 获取URL
    public func url() -> String {
        switch self {
        case .user:
            return "http://web.etzb.tv/"
        case .game188:
            switch AppConfig.state {
            case .debug:
                return "https://xj-mbs-yb5.2r9qgy.com/"
            default:
                return "https://xj-mbs-yb5.2r9qgy.com/"
            }
        case .gameIM:
            return "http://ipis-bwyabo.imapi.net/"
//            return "http://ykyule.sfsbws.test.imapi.net/"
        }
    }

    /// 获取该域名下请求头
    public func httpHeaders() -> HTTPHeaders {
        switch self {
        case .user:
            return HTTPHeaders(["d": "3"]) // 1:WEB 2:H5 3:iOS 4:Android
        case .game188:
            let headers: [String: String] = [
                "Accept": "*/*",
                "Accept-Encoding": "gzip, deflate, br",
                "Accept-Language": "zh-CN,zh;q=0.9,en;q=0.8",
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
                "Cookie": "ASP.NET_SessionId=42cz254rneerd2mwc2eoiaqf; sbmwl3-yb4=1829900042.20480.0000; redirect=done; lobbyUrl=localhost; logoutUrl=localhost; settingProfile=OddsType=1&NoOfLinePerEvent=1&SortBy=1&AutoRefreshBetslip=True; fav3=; favByBetType=; fav-com=; CCDefaultTvPlay=; CCDefaultBgPlay=; timeZone=480; opCode=YB5; mc=; BS@Cookies=; historyUrl=%2Fm%2Fzh-cn%2Fsports%2Fboxing%2Fselect-competition%2Fdefault%3Fsc%3DABIBAJ%26theme%3DYB5%7C%2Fm%2Fzh-cn%2Fsports%2Fhandball%2Fselect-competition%2Fdefault%3Fsc%3DABIBAJ%26theme%3DYB5%7C%2Fm%2Fzh-cn%2Fsports%2Fdarts%2Fselect-competition%2Fdefault%3Fsc%3DABIBAJ%26theme%3DYB5%7C%2Fm%2Fzh-cn%2Fsports%2Fice-hockey%2Fselect-competition%2Fdefault%3Fsc%3DABIBAJ%26theme%3DYB5%7C%2Fm%2Fzh-cn%2Fsports%2Fspecials%2Fselect-competition%2Fdefault%3Fsc%3DABIBAJ%26theme%3DYB5%7C%2Fm%2Fzh-cn%2Fsports%2Fgolf%2Fselect-competition%2Fdefault%3Fsc%3DABIBAJ%26theme%3DYB5%7C%2Fm%2Fzh-cn%2Fsports%2Fcricket%2Fselect-competition%2Fdefault%3Fsc%3DABIBAJ%26theme%3DYB5%7C%2Fm%2Fzh-cn%2Fsports%2Ffinancial-bets%2Fselect-competition%2Fdefault%3Fsc%3DABIBAJ%26theme%3DYB5%7C%2Fm%2Fzh-cn%2Fsports%2Fbasketball%2Fselect-competition%2Fdefault%3Fsc%3DABIBAJ%26theme%3DYB5%7C%2Fm%2Fzh-cn%2Fsports%2Fbasketball%2Fcompetition%2Ffull-time-asian-handicap-and-over-under%3Fsc%3DABIBAJ%26competitionids%3D27096%26theme%3DYB5",
                "Origin": "https://xj-mbs-yb5.2r9qgy.com",
                "Referer": "https://xj-mbs-yb5.2r9qgy.com/m/zh-cn/sports/?sc=ABIAJJ&theme=YB5",
                "sec-fetch-dest": "empty",
                "sec-fetch-mode": "cors",
                "sec-fetch-site": "same-origin"
            ]
            return HTTPHeaders(headers)
        case .gameIM:
            return HTTPHeaders()
        }
    }
}
