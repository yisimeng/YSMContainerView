# WeiboProfile
新浪微博用户详情页实现
思路：
 1、使用ScrollView和tableView嵌套

 2、ScrollView控制左右切换多个tableView

 3、tableView共用一个headerView

 **4、当scrollView开始滑动（左右切换）时，在scrollViewWillBeginDragging方法中，先将headerView添加到scrollView或者更外层的view上**

 **5、继续滑动调用scrollViewDidScroll方法，如果是添加在scrollView上，则需要不断计算scrollView的contentOffset.x值设置为view.left**

 **6、当左右滑动结束后，需要将headerView放回当前的tableView的headerView上。**

 7、tableView上下滚动时，headerView是作为tableView.tableHeaderView的子视图跟随当前的tableView滚动的。
注意到一个小细节，当最外层的tableView滑动的时候，左侧的垂直滚动条并不是从页面的顶部开始的，而是从下部cell处开始的，给人直观的感觉是headerView并不属于tableView，而是分开的视觉假象，这个可以通过设置tableView的scrollIndicatorInsets属性控制滚动条的起始位置（已添加）。
<center>![weibo](weibo.gif)</center>



# 支付宝首页的滚动实现
现象：
1、向上滚动时，上面部分随着tableView一起向上滚动。
2、向下滑动时，当上部分全部显示后不再向下滑动，只有下部分的tableView滑动并调出header刷新。

思路：
1、设置tableView的contentInset，内容的偏移，偏移出一个header的高度
2、header的top设置成负值，添加到tableView上（不使用tableView的原因是，下拉刷新是在header的下面）
3、通过scrollViewDidScroll获取到滑动的偏移，当tableView的偏移量小于负的contentInset.top时，说明是向下滚动，设置headerview的top等于当前的偏移，就能保持header一直在顶部，并且刷新视图在headerView的下面。而向上滑动时，只需要设置headerview.top保持在初始值情况下，就可以让其随着tableView一起滑动。
<center>![zfb](zfb.gif)</center>
