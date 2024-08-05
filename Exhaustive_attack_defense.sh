if [ "$(id -u)" -ne 0 ]; then
   echo "该脚本需以root用户运行！"
   exit
fi

while true
do

GITHUB_URL="https://github.com/yyhhkya/Exhaustive_attack_defense"
log_num=$(wc -l < /var/log/auth.log)
verification_failed=$(grep "Failed password" /var/log/auth.log | wc -l)


clear

echo ""
echo "+----------------------------------------------------------------------------------+"
echo "| 本脚本通过分析log日志检查服务器是否被暴力破解                                    |"
echo "|                                                                                  |"
echo "| 已集成一些暴力破解预防手段                                                       |"
echo "|                                                                                  |"
echo "| GitHub项目地址 ${GITHUB_URL}              |"
echo "+----------------------------------------------------------------------------------+"
echo ""
echo "当前日志条数: ${log_num}"
echo "当前验证失败次数: ${verification_failed}"
echo ""
echo "> 菜单 <"
echo ""
echo "[0]退出脚本"
echo "---"
echo "[1]统计登录成功的IP"
echo "[2]统计登录成功的用户"
echo "---"
echo "[3]统计登录失败的IP"
echo "[4]统计登录失败的用户"
echo "---"
echo "[5]一键禁止root用户以外的用户登录"
echo "[6]一键禁止使用密钥登录"
echo "---"
echo "[7]重启SSH服务"
echo ""
read -p "请输入序号: " num

if [ ${num} = 0 ]; then
    exit
elif [ ${num} = 1 ]; then
    echo ""
    echo "登录成功的IP(旧->新):"
    grep "Accepted" /var/log/auth.log | awk '{print $11}' | sort | uniq -c
    read
elif [ ${num} = 2 ]; then
    echo ""
    echo "登录成功的用户(旧->新):"
    grep "Accepted" /var/log/auth.log | awk '{print $9}' | sort | uniq -c
    read
elif [ ${num} = 3 ]; then
    echo ""
    echo "登录失败的IP:"
    lastb | awk '{print $3}' | sort | uniq -c | sort -nr
    read
elif [ ${num} = 4 ]; then
    echo ""
    echo "登录失败的用户:"
    lastb | awk '{print $1}' | sort | uniq -c | sort -nr
    read
elif [ ${num} = 5 ]; then
    result=$(grep -nE '^AllowUsers' /etc/ssh/sshd_config)
    if [ -n "${result}" ]; then
        line_number=$(echo "${result}" | cut -d: -f1)
        content=$(echo "${result}" | cut -d: -f2-)
        echo ""
        echo "已存在相关配置，停止操作！"
        echo "位于第 ${line_number} 行: ${content} "
    else
        echo -e "\n\n# Exhaustive_attack_defense Config(一键禁止root用户以外的用户登录)\nAllowUsers root" | tee -a /etc/ssh/sshd_config > /dev/null
        echo ""
        echo "已执行操作！"
        echo "请重启SSH服务以应用配置"
    fi
    read
elif [ ${num} = 6 ]; then
    result=$(grep -nE '^PubkeyAuthentication' /etc/ssh/sshd_config)
    if [ -n "${result}" ]; then
        line_number=$(echo "${result}" | cut -d: -f1)
        content=$(echo "${result}" | cut -d: -f2-)
        echo ""
        echo "已存在相关配置，停止操作！"
        echo "位于第 ${line_number} 行: ${content} "
    else
        echo -e "\n\n# Exhaustive_attack_defense Config(一键禁止使用密钥登录)\nPubkeyAuthentication no" | tee -a /etc/ssh/sshd_config > /dev/null
        echo ""
        echo "已执行操作！"
        echo "请重启SSH服务以应用配置"
    fi
    read
elif [ ${num} = 7 ]; then
    echo ""
    systemctl restart sshd
    echo "已执行重启！"
    read
fi

done


