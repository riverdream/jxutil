- 使用时，需要安装 sshpass
- 使用 SSH 公私钥认证，可以不需要密码。

```
$./jxutil.sh scp
$./jxutil.sh exec "cd /opt; rm xxx"
$./jxutil.sh execprint "cd /opt; ls"
```

> 注意：
> 1、双引号必须有，如果不加双引号，第二个ls命令在本地执行。
> 2、分号，两个命令之间用分号隔开.
