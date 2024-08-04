while true
do

GITHUB_URL="https://github.com/yyhhkya/Login_analysis"
log_num=$(wc -l < /var/log/auth.log)
verification_failed=$(grep "Failed password" /var/log/auth.log | wc -l)


clear

echo ""
echo "+----------------------------------------------------------------------------------+"
echo "| This script analyzes whether the LOG log checking the server is cracked by brute |"
echo "| 本脚本通过分析log日志检查服务器是否被暴力破解                                    |"
echo "|                                                                                  |"
echo "| GitHub项目地址 ${GITHUB_URL}                         |"
echo "+----------------------------------------------------------------------------------+"
echo ""
echo "当前日志条数: ${log_num}"
echo "当前验证失败次数: ${verification_failed}"
echo ""
echo "> 菜单 <"
echo "[0]退出脚本"
echo "---"
echo "[1]统计登录成功的IP"
echo "[2]统计登录成功的用户"
echo "---"
echo "[3]统计登录失败的IP"
echo "[4]统计登录失败的用户"
echo ""
read -p "请输入序号: " num

if [ ${num} = 0 ]; then
    exit
elif
    [ ${num} = 1 ]; then
    echo ""
    echo "登录成功的IP(旧->新):"
    grep "Accepted" /var/log/auth.log | awk '{print $11}' | sort | uniq -c
    read
elif
    [ ${num} = 2 ]; then
    echo ""
    echo "登录成功的用户(旧->新):"
    grep "Accepted" /var/log/auth.log | awk '{print $9}' | sort | uniq -c
    read
elif
    [ ${num} = 3 ]; then
    echo ""
    echo "登录失败的IP:"
    lastb | awk '{print $3}' | sort | uniq -c | sort -nr
    read
elif
    [ ${num} = 4 ]; then
    echo ""
    echo "登录失败的用户:"
    lastb | awk '{print $1}' | sort | uniq -c | sort -nr
    read
fi

done


