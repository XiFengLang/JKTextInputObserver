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
@interface AccountInputView () <UITextFieldDelegate,JKTextInputObserverDelegate>

@property (nonatomic, strong) JKTextInputObserver * phoneObserver;
@property (nonatomic, strong) JKTextInputObserver * captchObserver;

@end


phoneTF.delegate = self;
_phoneObserver = [[JKTextInputObserver alloc] initWithTextField:phoneTF];
_phoneObserver.maximumLength = 11;            // 最多11位字符
_phoneObserver.matchRegular = @"^[0-9]\\d*$"; // 只能输入数字
_phoneObserver.delegate = self;



/// 必须实现此协议方法，以实现字符过滤
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.phoneObserver.textField) {
        return [self.phoneObserver jk_textField:textField range:range shouldChangeString:string];
    }
    return [self.captchObserver jk_textField:textField range:range shouldChangeString:string];
}



```

**常用正则**

```C
数字			^[0-9]\\d*$    
英文+数字		^[A-Za-z0-9]+$
中英文+数字		^[a-zA-Z\u4E00-\u9FA5\\u0030-\\u0039➋-➒]+$

```


