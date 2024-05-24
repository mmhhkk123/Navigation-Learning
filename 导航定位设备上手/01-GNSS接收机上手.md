<div align="center">
    <a name="Top"></a>
	<h1>GNSS 接收机上手</h1>
    <img alt="Static Badge" src="https://img.shields.io/badge/QQ-1482275402-red">
    <img alt="Static Badge" src="https://img.shields.io/badge/%E5%BE%AE%E4%BF%A1-lizhengxiao99-green">
    <img alt="Static Badge" src="https://img.shields.io/badge/Email-dauger%40126.com-brown">
    <a href="https://blog.csdn.net/daoge2666/"><img src="https://img.shields.io/badge/CSDN-论坛-c32136" /></a>
    <a href="https://www.zhihu.com/people/dao-ge-92-60/"><img src="https://img.shields.io/badge/Zhihu-知乎-blue" /></a>
    <img src="https://komarev.com/ghpvc/?username=LiZhengXiao99&label=Views&color=0e75b6&style=flat" alt="访问量统计" />
</div>


<br/>

GNSS 接收机可以用于测绘、导航、

GNSS 接收机的形式也有很多

板卡、模块、整机、芯片





学界对于 GNSS 的研究

* 授时：
* 对流层建模：
* 电离层建模：
* 重力场：
* 海平面：

本篇还是主要



GNSS 的基本原理是空间后方交会

我们知道



距离是由信号传播时间

时间的准确性至关重要，1ns 的时间误差引起 3m 的定位误差

卫星上的时间由原子时来维持

而接收机上只有低成本的晶振，

接收机钟差也作为参数估计





高精度的定位解算方法包括：

<img src="https://pic-bed-1316053657.cos.ap-nanjing.myqcloud.com/img/image-20240419154548594.png" alt="image-20240419154548594" style="zoom: 80%;" />

* RTK：
* PPP：模糊度固定和实时快速 PPP 是目前主要的研究方向
* PPP-RTK：区域参考网增强精密单点定位

> 推荐阅读：[学术交流丨辜声峰：从RTK、PPP到PPP-RTK](https://mp.weixin.qq.com/s?__biz=MzI1NTA2MzYxMg==&mid=2650089381&idx=4&sn=95172abc0d83410c2b861343f52294ba)





GNSS 板卡是由基带芯片、射频芯片、外围电路和相应的嵌入式控制软件制成带输入输出接口的基础集成电路板，是高精度GNSS接收机的核心部件；模块是集成度更高的板卡。







有些接收机带IMU，

有些接收机带通信，





上面介绍的是接收机的内部原理，

如果不做信号层的算法，了解即可，

做数据处理算法，把 GNSS 接收机内部当成，我们只需要知道接收机输出了：

* **测码伪距**：
* **载波相位**：在高精度数据算法中发挥了关键的作用
* **多普勒频移**：用来定速，精度比伪距高
* **信噪比**：用于衡量观测值质量，也用于反演
* **导航电文**：
  * **星历**：
  * **历书**：
  * **卫星钟差**：
  * **跳秒信息**：
  * **电离层模型**：
  * **TGD**：
  * **偏差参数**：
  * **PPP 改正**：Galileo HAS、北斗 B2b
  * 





小米 8 算是是最早支持双频 GNSS 数据输出的手机，有不少研究手机定位的论文，都基于小米 8；

23 年华为 Mate 60，已经可以输出四频北斗数据，但听说因为鸿蒙系统的限制，无法获取 GNSS 原始数据





GNSS 接收机输出的主要有三种：

* NMEA：
* RTCM：
* 接收机原始数据：





主流的接收机大多提供上位机，





卫导原理：空间交会定位





卫星信号发射功率也就二三十瓦，传到地面被接收机天线的时候非常低了，



接收机的内部实现，和通信设备很相似，几乎就是一样的

很多软件接收机的，

有专用的 GNSS 射频芯片，通用射频芯片

UARP、HackRF 等软件接收机，既可以通信，也可以做 GNSS 接收机

很多 GNSS 接收机都是电子通信相关专业在做，做 GNSS 基带算法的可以很方便的转向 6G 接收机原型开发，

做通信的也很容易转向 GNSS 接收机研发，

我想正是应为这样，民用 GNSS 接收机才发展的如此迅速



接收机质量的性能好坏很大程度上取决于基带算法，



串联器件的噪声指数主要取决于第一级器件，

所以第一级往往是低噪声放大器

有源天线







最后总结一下，对于一款 GNSS 接收机，咱们应该重点关注的东西：

* **卫星系统数**：现在主流是六大系统：美国 GPS、俄罗斯 GLONASS、中国 BDS、欧洲 Galileo、印度 IRNSS、日本 QZSS。
* **每个系统的频点数**：是否支持北斗三新频点，
* **输出数据类型**：可以输出 RTCM 或其它形式的原始数据，还是是只支持输出 NMEA 定位结果
* **是否支持差分解算**：就是传入差分数据到接收机，能进行 RTK、RTD 计算
* **电压范围**：对于板卡一般是 9~36V，对于模块一般是 CMOS、TTL 电平
* **是否支持 PPS 输出**：
* **是否支持有源天线**：如果不支持，那就不能用太长的馈线
* **上位机**：功能是否完善，其实这条也没那么重要，因为我们可能只有测试的时候用上位机
* **手册是否完善**：
* **是否有测试数据**：
* **其它功能**：双天线、惯导、通信、抗欺骗、电离层抑制、可编程IO、插 SD 卡存数据、

