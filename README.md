# HCRefresh
HCRefresh是一款简单易用的刷新框架

## 效果展示


![](https://raw.githubusercontent.com/gmfxch/HCRefresh/master/refresh3.gif)



## 使用示例
### 添加刷新（selector方式）

```objc
    [scrollView hc_addHeaderRefreshWithTarget:self actionSelector:@selector(headerRefresh)];
    [scrollView hc_addFooterRefreshWithTarget:self actionSelector:@selector(footerRefresh)];
    
```

### 添加刷新（block方式）
```objc
    [scrollView hc_addHeaderRefreshWithActionBlock:^{
        
    }];
    
    [scrollView hc_addFooterRefreshWithActionBlock:^{
        
    }];
    
```

### 自定义UI
```objc
    //顶部刷新文字的颜色（默认灰色）
    [HCRefreshManager shareManager].refreshTitleColor = HC_UICOLOR_RGB(100, 100, 100);
    //顶部显示的刷新文字内容
    [HCRefreshManager shareManager].refreshTitle = @"HCRefresh";
    //顶部刷新文字的字体（默认系统加粗字体24号）
    [HCRefreshManager shareManager].refreshTitleFont = [UIFont boldSystemFontOfSize:24];
    //顶部刷新文字在显示动画时的高亮颜色（默认白色）
    [HCRefreshManager shareManager].refreshTitleTinColor = HC_UICOLOR_RGB(255, 255, 255);
    //底部触发高度（默认为0，即UIScrollView刚好滑到底部就触发FooterRefresh）
    [HCRefreshManager shareManager].footerRefreshHeight = 0;
    
```




