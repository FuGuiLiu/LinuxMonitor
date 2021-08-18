# 声明
> 本项目后端来自 https://github.com/xkcoding/spring-boot-demo  本人修改了前端UI界面,让服务器信息更直观

---

# 功能介绍
- 查询服务器的 CPU 内存 还有磁盘 使用情况

---
## 2. 运行方式
```bash
 bash <(curl -Ls https://raw.githubusercontent.com/FuGuiLiu/LinuxMonitor/master/monitor.sh)
```

---

## 3. 运行效果

![](https://raw.githubusercontent.com/FuGuiLiu/LinuxMonitor/master/src/main/resources/static/images/img.png)
![](https://raw.githubusercontent.com/FuGuiLiu/LinuxMonitor/master/src/main/resources/static/images/img_1.png)

---

### 4.1. 后端
1. Spring Boot 整合 Websocket 官方文档：https://docs.spring.io/spring/docs/5.1.2.RELEASE/spring-framework-reference/web.html#websocket
2. 服务器信息采集 oshi 使用：https://github.com/oshi/oshi

---

### 4.2. 前端
1. vue.js 语法：https://cn.vuejs.org/v2/guide/
2. element-ui 用法：http://element-cn.eleme.io/#/zh-CN
3. stomp.js 用法：https://github.com/jmesnil/stomp-websocket
4. sockjs 用法：https://github.com/sockjs/sockjs-client
5. axios.js 用法：https://github.com/axios/axios#example
