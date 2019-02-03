#!/bin/bash

# 使用时，需要安装 sshpass

userName=pengjx
password=00        # 使用 ssh 公私钥认证的，可以不需要密码。
port=22

# 管理机器的 ip 列表
ipArr=(
    192.168.16.114
    192.168.16.115
    192.168.16.116
    192.168.16.117
)

# 常用命令自定义封装 SCP
function util_scp()
{
    #自定义 cmd 命令
    scpCmd="cd /opt; rm -f xxx zzz"
    remotePath=/opt
    bin1=xxx    # 需要 scp 的的 bin 程序
    bin2=zzz

    echo "scp start ..."
    for ((i=0; i< ${#ipArr[*]}; i++))
    do
        sshpass -p $password ssh -p $port $userName@${ipArr[$i]} -o StrictHostKeyChecking=no $scpCmd
        sshpass -p $password scp -P $port $bin1 $userName@${ipArr[$i]}:$remotePath
        sshpass -p $password scp -P $port $bin2 $userName@${ipArr[$i]}:$remotePath

        echo "scp ${ipArr[$i]} ok"
    done

    echo "scp end"
    echo ----------------------
    #echo "array len:${#ipArr[*]}"
}

function util_stop()
{
    stopCmd="cd /opt; ./xxx stop"

    echo "stop start ..."
    for ((i=0; i< ${#ipArr[*]}; i++))
    do
        sshpass -p $password ssh -p $port $userName@${ipArr[$i]} -o StrictHostKeyChecking=no $stopCmd
        echo "stop ${ipArr[$i]} ok"
    done

    echo "stop end"
    echo ----------------------
}

function util_start()
{
    # 启动远程 bin 程序时，需要添加 “> /dev/null 2>&1 &”, 否则不能退出。
    startCmd="cd /opt; ./xxx > /dev/null 2>&1 &"

    echo "start start ..."
    for ((i=0; i< ${#ipArr[*]}; i++))
    do
        sshpass -p $password ssh -p $port $userName@${ipArr[$i]} -o StrictHostKeyChecking=no $startCmd
        echo "stop ${ipArr[$i]} ok"
    done

    echo "start end"
    echo ----------------------
}

# 执行远端命令，不在本地打印输出。
function util_exec()
{
    execCmd="`echo ${@:1}`"" > /dev/null 2>&1 &"

    for ((i=0; i< ${#ipArr[*]}; i++))
    do
        sshpass -p $password ssh -p $port $userName@${ipArr[$i]} -o StrictHostKeyChecking=no $execCmd
    done
}

# 执行远端命令，打印输出结果。
function util_execprint()
{
    execCmd="`echo ${@:1}`"

    for ((i=0; i< ${#ipArr[*]}; i++))
    do
        sshpass -p $password ssh -p $port $userName@${ipArr[$i]} -o StrictHostKeyChecking=no $execCmd
    done
}

# e.g. ./jxutil.sh scp
#      ./jxutil.sh exec "cd /opt; rm xxx"
#      ./jxutil.sh execprint "cd /opt; ls"

#注意：1、双引号必须有，如果不加双引号，第二个ls命令在本地执行。
#      2、分号，两个命令之间用分号隔开。

# 自定义快捷命令
case $1 in
    scp)
    util_scp
    ;;

    stop)
    util_stop
    ;;

    start)
    util_start
    ;;

    exec)
    exeCmd=`echo ${@:2}`
    util_exec $exeCmd
    ;;

    execprint)
    exeCmd=`echo ${@:2}`
    util_execprint $exeCmd
    ;;
esac

