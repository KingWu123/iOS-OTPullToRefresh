# OTPullToRefresh

These UIScrollView categories makes it super easy to add pull-down-refresh and pull-up-refresh to any UIScrollView (or any of its subclass). Instead of relying on delegates and/or subclassing `UIViewController`, OTPullToRefresh uses the Objective-C runtime to add the following 2 key methods to `UIScrollView`:

```objective-c
- (void)addPullDownRefreshWithAction:(OTPullActionHandler)handler type:(OTPullDownRefreshType)type;
- (void)addPullUpRefreshWithAction:(OTPullActionHandler)handler type:(OTPullUpRefreshType)type;


## Installation


### Manually

_**Important note if your project doesn't use ARC**: you must add the `-fobjc-arc` compiler flag to `UIScrollView+OTPullToRefresh.m` , `OTPullRefreshBaseView.m`, `OTPullUpRefreshView.m` and `OTPullDownRefreshView.m` in Target Settings > Build Phases > Compile Sources._

* Drag the `OTPullToRefresh/OTPullRefresh` folder into your project and add all of it's files to your project

## Usage

(see sample Xcode project in `ViewController.m`)

### Adding Pull Down Refresh

```objective-c
[tableView addPullDownRefreshWithAction:^{
    // prepend data to dataSource, insert cells at top of table view
    // call [tableView.pullDownRefreshDataSuccess:isSuccess] when done
} type:OTPullUpRefreshTypeDefault];
```
or if you want pull Up refresh from the bottom

```objective-c
[tableView addPullUpRefreshWithAction:^{
    // prepend data to dataSource, insert cells at bottom of table view
    // call [tableView.pullUpRefreshDataSuccess:isSuccess] when done
}  type:OTPullUpRefreshTypeDefault];
```

If you’d like to programmatically trigger the pull down refresh (for instance in `viewDidAppear:`), you can do so with:

```objective-c
[tableView autoTriggerPullDownRefresh];
```
 
## Under the hood

OTPullToRefresh extends `UIScrollView` by adding new public methods. 

It uses key-value observing to track the scrollView's `contentOffset`, `contentSize` and `frame`.

## Credits

OTPullToRefresh is brought to you by [King Wu] and [contributors to the project](https://github.com/). If you have feature suggestions or bug reports, feel free to help out by sending pull requests or by [creating new issues](https://github.com/). If you're using OTPullToRefresh in your project, attribution would be nice. 

Big thanks to [@Sam Vermette]for his [SVPullToRefresh](https://github.com/samvermette/SVPullToRefresh/contributors) talk which really helped for this project. 
