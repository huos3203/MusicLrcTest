# 使用帮助
原理：
![](LrcTest/daotuu.jpg)
## 安装

### 第一种方法
核心代码只有`MusicLrcView.h/m`和`MusicLrcParser.h/m`四个文件
将直接拷贝到项目中，然后`import "MusicLrcView.h"`使用即可

### 两种pod方式 

直接在Podfile文件使用pod方法
---
```ruby
pod 'MusicLrc', :git => 'https://github.com/huos3203/MusicLrcTest.git'
```
然后，在项目目录pod安装
```ruby 
$ pod install
```

通过私库集成
---
1. 加入你的pod本地私有库中：

    $ pod repo add PodRepo https://github.com/huos3203/PodRepo.git
2. 在终端查询`MusicLrc`

    $ pod search MusicLrc

        -> MusicLrc (0.0.2)
        Just Testing.
        pod 'MusicLrc', '~> 0.0.2'
        - Homepage: https://github.com/huos3203/MusicLrcTest
        - Source:   https://github.com/huos3203/MusicLrcTest.git
        - Versions: 0.0.2 [PodRepo repo]
3. 在Podfile文件中配置：

    $ pod 'MusicLrc', '~> 0.0.2'
4. 在项目目录pod安装

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
-(void)switchLrcOfMusic:(NSString *)lrcPath player:(AVPlayer *)player lrcDelegate:(id<MusicLrcDelegate>)lrcDelegate;
功能：
1. 用于初始化界面之后，加载歌词到歌词界面上。
2. 在切换歌曲时，同步切换歌词
调用方式：
```objc
[[MusicLrcView shared] switchLrcOfMusic:lrcPath player:_player lrcDelegate:self];
```
`lrcPath`: lrc格式歌词路径
`_player`:播放器实例
`self`:遵循`MusicLrcDelegate`协议类自身
## 两个代理
自定义外观样式
```objc
//代理
@protocol MusicLrcDelegate <NSObject>

//重设高亮歌词颜色
-(UIColor *)setHighlightLrcColor;

-(UIColor *)setLrcColor;

@end
```


具体过程：
```objc
//添加音频路径
NSString *lrcPath = [[NSBundle mainBundle] pathForResource:@"qbd" ofType:@"lrc"];
MusicLrcView *lrcView = [MusicLrcView shared];
[lrcView switchLrcOfMusic:lrcPath player:_player lrcDelegate:self];
[self.view addSubview:lrcView];

```
