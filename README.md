# HCRefresh
HCRefresh是一款简单易用的刷新框架

## 效果展示


![](http://obs82vgf8.bkt.clouddn.com/refresh.gif)



## 使用示例

```objc
//*********添加刷新（selector方式）*********
    [scrollView hc_addHeaderRefreshWithTarget:self actionSelector:@selector(headerRefresh)];
    [scrollView hc_addFooterRefreshWithTarget:self actionSelector:@selector(footerRefresh)];
    
```


