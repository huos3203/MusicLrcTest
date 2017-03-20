# 使用帮助
原理：
![](LrcTest/daotuu.jpg)
## 安装：
核心代码只有两个`MusicLrcView`和`MusicLrcParser`文件：
第一种方法直接拷贝到项目中，import "MusicLrcView.h"即可
第二种：直接在Podfile文件使用pod方法：
{% codeblock lang:git %}
pod 'MusicLrc', :git => 'https://github.com/huos3203/MusicLrcTest.git'
{% endcodeblock %}
第三种：
1. 加入你的pod本地私有库中：
{% codeblock lang:ruby %}
pod repo add PodRepo https://github.com/huos3203/PodRepo.git
{% endcodeblock %}
2. 在终端查询`MusicLrc`
{% codeblock lang:ruby %}
pod search MusicLrc
-> MusicLrc (0.0.2)
Just Testing.
pod 'MusicLrc', '~> 0.0.2'
- Homepage: https://github.com/huos3203/MusicLrcTest
- Source:   https://github.com/huos3203/MusicLrcTest.git
- Versions: 0.0.2 [PodRepo repo]
{% endcodeblock %}
3. 在Podfile文件中配置：
{% codeblock lang:ruby %}
pod 'MusicLrc', '~> 0.0.2'
{% endcodeblock %}

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
