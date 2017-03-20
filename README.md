# WeiboProfile
新浪微博用户详情页实现   
思路：   
 1、使用ScrollView和tableView嵌套   
 
 2、ScrollView控制左右切换多个tableView    
 
 3、tableView共用一个headerView    
 
 **4、当scrollView开始滑动（左右切换）时，在scrollViewWillBeginDragging方法中，先将headerView添加到scrollView或者更外层的view上**   
 
 **5、继续滑动调用scrollViewDidScroll方法，如果是添加在scrollView上，则需要不断计算scrollView的contentOffset.x值设置为view.left**    
 
 **6、当左右滑动结束后，需要将headerView放回当前的tableView的headerView上。**   
 
 7、tableView上下滚动时，headerView是作为tableView.tableHeaderView的子视图跟随当前的tableView滚动的   
