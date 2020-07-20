# 使用正则表达式，重新定义解析歌词的算法

该版本选择通过正则表达式来实现，只需一行正则表达式，即可解决一切问题。

代码中日期正则表达式：
```
"\\d{1,2}:\\d{2}.\\d{2}"
```
当日期正则在当前匹配成功，则可断定为合法行。

通过以下代码来获取到当前行的歌词内容：
```
NSRange lastRange = [[matchs lastObject] rangeAtIndex:0];
NSString *lrcc = [lineText substringFromIndex:lastRange.location + lastRange.length + 1];
```
> 以前版本在解析时，使用字符串截取来解析歌词，由于lrc格式多样化，很容易导致异常。

# 使用帮助
原理：
<!--![](LrcTest/daotuu.jpg)-->

## 安装

### 第一种方法
核心代码只有`MusicLrcView.h/m`和`MusicLrcParser.h/m`四个文件
将直接拷贝到项目中，然后`import "MusicLrcView.h"`使用即可

### ~~第二种动态框架~~
在混编编译过程中，出现内核支持问题。（暂时废弃）
直接下载`MusicLRC.framework`，导入到项目中。
```
#import <MusicLRC/MusicLrcView.h>
```

### 两种pod方式 

直接在Podfile文件使用pod方法
---
```ruby
pod 'MusicLrc', :git => 'https://github.com/it-boyer/MusicLrcTest.git'
```
然后，在项目目录pod安装
```ruby 
$ pod install
```

安装PodRepo私库方式
---
1. 加入你的pod本地私有库中：

    $ pod repo add PodRepo https://github.com/it-boyer/PodRepo.git
2. 在终端查询`MusicLrc`

    $ pod search MusicLrc

        -> MusicLrc (0.0.2)
        使用正则表达式，重新定义解析歌词的算法
        pod 'MusicLrc', '~> 3.2'
        - Homepage: https://github.com/it-boyer/MusicLrcTest
        - Source:   https://github.com/it-boyer/MusicLrcTest.git
        - Versions: 3.2, 3.0, 2.0, 0.0.2 [podRepo repo]
3. 配置Podfile文件：
    source 'https://github.com/it-boyer/PodRepo.git'
    
    pod 'MusicLrc', '~> 3.2'
4. 在项目根目录安装

    $ pod install

## 保留两个接口：
### 类方法
```objc
+(MusicLrcView *)shared;
```
用于初始化显示的歌词页面，其中具体实现是通过`tableView`相关接口，来实现显示和用户的相关交互功能。
```objc
[self.view addSubview:[MusicLrcView shared]];
```
### 切换歌词实例方法
功能：
1. 用于初始化界面之后，加载歌词到歌词界面上。
2. 在切换歌曲时，同步切换歌词
调用方式：
```objc
-(void)loadLrcBy:(NSString *)lrcPath audioPlayer:(AVAudioPlayer *)player lrcDedegate:(id<MusicLrcDelegate>)lrcDelegate;
```
`lrcPath`: lrc格式歌词路径
`audioPlayer`:`AVAudioPlayer`播放器实例
`lrcDelegate`:遵循`MusicLrcDelegate`协议的类
## 自定义外观样式的代理协议
```objc
//代理
@protocol MusicLrcDelegate <NSObject>

//重设高亮歌词颜色
-(UIColor *)musicLrcHighlightColor;

-(UIColor *)musicLrcColor;

-(UIImage *)visualEffectImage;

-(BOOL)refreshAllLrcColor;

-(void)refreshFinish;
@end
```

具体过程：
```objc
//添加音频路径
MusicLrcView *lrcView = [MusicLrcView shared];
[[MusicLrcView shared] loadLrcBy:@"荷塘月色" audioPlayer:_audioPlayer lrcDedegate:self];
[self.view addSubview:lrcView];

```
## 新增功能

### 下载歌词，并同步至播放器
HttpClientManager是使用Swift编写，需要注意-Swift.h映射文件
```objc
[HttpClientManager.shareInstance loadLrcByLrcModel:lrcmodel player:_audioPlayer lrcDelegate:self completion:^(BOOL finished,NSString * loginfo) {
    
}];
```

```swift


```
### 音乐播放器定时关闭功能


