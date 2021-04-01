# LFSDK 介绍

LFSDK基础工程依赖库

## Features

- [x] 网络模块Api
- [x] 路由模块PageRouter
- [x] Toast
- [x] 系统、UI配置
- [x] UI组件库
- [x] 语言本地化
- [x] 数据存储UserDefaults
- [ ] 统一的WebView
- [ ] 下拉刷新控件
- [ ] sqlite/iclould

## Requirements

- iOS 11+ / macOS 11.0+ / xcode11.0+
- Swift 5.0+
- cocoapods 1.9.0+

### Installation

1. `git clone http://git.gitcodex.com/ios/YMSDK.git`
2. `cd ymsdk && pod install`
3. open ymsports.xcworkspace in xcode and click run.


### 其他工程引用
`pod 'YMSDK', :git => 'http://git.gitcodex.com/ios/YMSDK.git'`

#### 注意事项
- `YMSDK`是与业务无关的基础库，所有项目都依赖它
- 源码（xib、资源文件、.swift）都放在`YMSDK`目录下
- 开发新功能需要拉分支，自测通过后合并到master，参考`Git分支命名规范`
- 开发SDK framework时需要把功能单元测试跑通过再提交代码，测试代码放在`ymsdkdemo`中
- 提交代码后注意打tag  `git tag v0.0.1 commitId`
- 如果`ymsdkdemo`编译找不到`YMSDK`请先 `⌘+⇧+K` => 选中`YMSDK` target => `⌘+B` => 选中`ymsdkdemo` target => `⌘+B`



### 项目结构

```
ProjectRoot
    |_ .gitignore       # 定义git忽略记录
    |_ CHANGELOG.md     # 每个版本的修改内容记录
    |_ Podfile          # cocoapods依赖管理
    |_ Docs/            # 项目文档
    |_ ymsdk/        # 主项目
        |_ Base/        # 各种基类，例如BaseViewController
        |_ Config/      # app配置文件
        |_ Entry/       # app入口
        |_ Api/         # 网络和Api请求接口
        |_ Kit/         # UI组件库
        |_ Utils/       # 工具目录
            |_ Router   # 页面统一跳转
            |_ Toast    # Toast相关
            |_ Extions  # 分类相关
            |_ ...
        |_ Vendor/      # 手动集成的三方库
        |_ Resources/   # 资源文件，images、fonts、json、file
        |_ Support Files/       # 支持文件目录，Info.plist 本地化等
```


### Git提交规范
- `feat` :     新功能 feature
- `fix` :      修复 bug
- `docs` :      文档注释
- `style` :  代码格式(不影响代码运行的变动)
- `test` :    增加测试
- `chore` :  构建过程或辅助工具的变动


### Git分支命名规范
- `feature` 新功能开发分支，例如：feature/refresh
- `fix` 问题修复分支，例如：fix/unexpected-ref
- `master` 最终分支用来部署的

待功能自测完成后合并到`master`，更新文档说明并打`tag`更新版本号



### 代码开发规范

[Swift开发规范](Docs/swift-rules.md)


### Kit组件文档
- [ToastUtil HUD](Docs/toast.md)
- [Localized本地化](Docs/localized.md)
- [PopAlert通用弹框](Docs/popalert.md)
- [AppConfig](Docs/appconfig.md)
- [UIConfig](Docs/uiconfig.md)
- [Foundation扩展](Docs/foundation.md)
- [UIKit扩展](Docs/uikit.md)
- [Extions扩展](Docs/extions.md)
- [Api网络请求](Docs/api.md)
- [App通用跳转协议](Docs/jump.md)
