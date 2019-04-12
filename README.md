# JKTextInputObserver
监听UITextField和UITextView的输入，可能限定输入的长度和内容，比如限制11位数字（手机号码）


## CocoaPods

```C
platform :ios, '8.0'

source 'https://github.com/CocoaPods/Specs.git'

pod 'JKTextInputObserver', '~> 1.0.5'

```


## Usage

```C
#import <JKTextInputObserver/JKTextInputObserver.h>
```

```C
@property (nonatomic, strong) JKTextInputObserver * phoneObserver;
@property (nonatomic, strong) JKTextInputObserver * captchObserver;


_phoneObserver = [[JKTextInputObserver alloc] initWithTextField:phoneTF];
_phoneObserver.maximumLength = 11;            // 最多11位字符
_phoneObserver.matchRegular = @"^[0-9]\\d*$"; // 只能输入数字
_phoneObserver.delegate = self;


```
