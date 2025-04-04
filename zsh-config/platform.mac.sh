alias o='open'
alias oo='open .'
alias ll='ls -alhG --color=auto'
alias ls='ls --color=auto'
alias src='source ~/.zshrc'

export BSTEMP='/private/tmp'

function current_networkservice() {
    network=''
    if [ "$(networksetup -getnetworkserviceenabled Ethernet)" = 'Enabled' ]; then
       network='Ethernet'
    elif [ "$(networksetup -getnetworkserviceenabled Wi-Fi)" = 'Enabled' ]; then
       network='Wi-Fi'
    else
       network=''
    fi
    echo $network
}

function ip() {
    network=`current_networkservice`
    networksetup -getinfo $network | grep '^IP address' | awk -F: '{print $2}' | sed 's/ //g'
}

# Follow this page to avoid enter password
# http://apple.stackexchange.com/questions/236806/prevent-networksetup-from-asking-for-password
function proxy() {
    network=`current_networkservice`
    if [ -z network ]; then
        echo "Unrecognized network"
        return 1
    fi

    case "$1" in
    on)
        networksetup -setwebproxystate $network on;
        networksetup -setsecurewebproxystate $network on;
        networksetup -setwebproxy $network 127.0.0.1 8888;
        networksetup -setsecurewebproxy $network 127.0.0.1 8888;
        networksetup -setautoproxystate $network off;
        networksetup -setsocksfirewallproxystate $network off;
        ;;
    g)
        networksetup -setwebproxystate $network off;
        networksetup -setsecurewebproxystate  $network off;
        networksetup -setautoproxystate $network off;
        networksetup -setsocksfirewallproxy "$network" localhost 14179
        ;;
    off)
        networksetup -setwebproxystate $network off;
        networksetup -setsecurewebproxystate  $network off;
        networksetup -setautoproxystate $network off;
        networksetup -setsocksfirewallproxystate $network off;
        ;;
    s)
        socks_status=$(networksetup -getsocksfirewallproxy $network | head -n 3;)
        socks_enable=$(echo $socks_status | head -n 1 | awk '{print $2}')
        socks_ip=$(echo $socks_status | head -n 2 | tail -n 1 | awk '{print $2}')
        socks_port=$(echo $socks_status | tail -n 1 | awk '{print $2}')

        if [ "$socks_enable" = "Yes" ]; then
            echo -e "${green}Socks: ✔${NC}" $socks_ip ":" $socks_port
        else
            echo -e "${RED}Socks: ✘${NC}" $socks_ip ":" $socks_port
        fi

        http_status=$(networksetup -getwebproxy $network | head -n 3)
        http_enable=$(echo $http_status | head -n 1 | awk '{print $2}')
        http_ip=$(echo $http_status | head -n 2 | tail -n 1 | awk '{print $2}')
        http_port=$(echo $http_status | tail -n 1 | awk '{print $2}')

        if [ "$http_enable" = "Yes" ]; then
            echo -e "${green}HTTP : ✔${NC}" $http_ip ":" $http_port
        else
            echo -e "${RED}HTTP : ✘${NC}" $http_ip ":" $http_port
        fi

        https_status=$(networksetup -getsecurewebproxy $network | head -n 3)
        https_enable=$(echo $https_status | head -n 1 | awk '{print $2}')
        https_ip=$(echo $https_status | head -n 2 | tail -n 1 | awk '{print $2}')
        https_port=$(echo $https_status | tail -n 1 | awk '{print $2}')

        if [ "$https_enable" = "Yes" ]; then
            echo -e "${green}HTTPS: ✔${NC}" $https_ip ":" $https_port
        else
            echo -e "${RED}HTTPS: ✘${NC}" $https_ip ":" $https_port
        fi
        ;;
    *)
        echo "Usage: p {on|off|g|s}"
        echo "p on : Set proxy to Charles(port 8888)"
        echo "p off: Reset proxy to system default"
        echo "p g  : Set proxy to GoAgentx(port 14179)"
        echo "p s  : Show current network proxy status"
        echo "p *  : Show usage"
        ;;
    esac
}

alias p=proxy

function ow() {
    if [[ -n "$@" ]]; then
        (cd "$@" && ow)
    else
        if ls *.xcworkspace 2>&1 1>/dev/null; then
            for i in *.xcworkspace;open "$i"
        elif ls *.xcodeproj 2>&1 1>/dev/null; then
            for i in *.xcodeproj;open "$i"
        else
            echo "ERROR, xcode project not exists in '$(pwd)' !"
            echo "Use this in xcode project directory or use 'ow <DIRECTORY>'"
        fi
    fi
}

#如果不指定文件名，默认是当前目录下递归搜索，否则在指定文件名中搜索
function bsgrep() {
    if [ $# -eq 1 ]; then
        grep -rn "$1" .
    else
        grep -n "$1" "$pwd/$2"
    fi
}

function h(){
    # Remove zsh defualt numbe alias
    if `alias | grep -q "1="`; then
        for i in {1..9}; do
            unalias $i
        done
    fi

    history | grep --color=always -i $1 | awk '{$1="";print $0}' | grep -v '^ h' | # 查找关键字，去掉左侧的数字和 h 命令自身 \
    sort | uniq -c | sort -rn | awk '{$1="";print NR " " $0}' | # 先去重（需要排序）然后根据次数排序，再去掉次数 \
    tee ~/.macbootstrap/.histfile_color_result | gsed -r "s/\x1B\[([0-9]{1,3}((;[0-9]{1,3})*)?)?[m|K]//g" |  # 把带有颜色的结果写入临时文件，然后去除颜色 \
    awk '{$1="";print "function " NR "() {" $0 "; echo \": $(date +%s):0;"$0"\" >> ~/.histfile }"}' | # 构造 function，把 $0 写入到 histfile 中 \
    {while read line; do eval $line &>/dev/null; done}  # 调用 eval，让 function 生效
    cat ~/.macbootstrap/.histfile_color_result | sed '1!G;h;$!d' # 倒序输出，更容易看到第一条
}

# function pt() {
#     launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.polipo.plist
#     launchctl load ~/Library/LaunchAgents/homebrew.mxcl.polipo.plist
#     export http_proxy=http://localhost:8123
#     export https_proxy=http://localhost:8123
# }

function s() {
    word=$1
    cd ~/dev/DailyLearning
    ls | xargs cat | gawk 'BEGIN{RS="### "} {if(tolower($0) ~ /'"$word"'/)print "###", $0}' | egrep --color=always -i "$word|$|^"
    cd -
}

# File operatoin
function bssize() {
    location=$1
    if [ ${location} = "/" ]; then
        /bin/df -gH
        return
    fi

    if [ -d "${location}" ]; then
        pushd $PWD > /dev/null
        cd ${location}
        du -d 1 -h -c
        if [ ${location} != "." ]; then
            popd >/dev/null
        fi
    else
        if [ -f "${location}" ]; then
            du -h ${location}
        else
            echo "No such file or directory"
            return
        fi
    fi
}

mkcdir () {
    mkdir -p -- "$1" &&
    cd -P -- "$1"
}

function autojump_with_fzf() {
    local dir
    dir=$(cat ~/Library/autojump/autojump.txt | sort -nr | awk '{print $2}' | fzf +s) && cd "$dir"
}

function bsfn () {
    # Use -or to support multi types
    find . \( -type f -or -type l \) | egrep --color=always $1
}

# function bssclient () {
#     nohup sslocal -c ~/.macbootstrap/config/shadowsocks.conf &> $BSTEMP/nohup.out&
# }

function c() {
    if [ "$#" -eq 0 ]; then
        code .
    elif [ "$#" -eq 1 ]; then
        if [ -f $1 ]; then
            code $1
        elif [ -d $1 ]; then
            (cd $1 && code .)
        else
            (j $1 && code .)
        fi
    else
        echo "Usage: c or c path"
    fi
}

function bswhich() {
    if `type $1 | grep -q 'is a shell function'`; then
        type $1
        which $1
    elif `type $1 | grep -q 'is an alias'`; then
        PS4='+%x:%I>' zsh -i -x -c '' |& grep '>alias ' | grep "${1}="
    fi
}

# function wifipassword () {
#     SSID=`/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}'`
#     security find-generic-password -D "AirPort network password" -a "$SSID" -gw
# }

# Get resolution of image
function resolution() {
    brew_install -q exiv2
    exiv2 $1 | grep 'Image size' | column 4 5 6
}

# Show path of xcode(Xcode must be running)
function xcodepath() {
    ps `pgrep -x Xcode` R 2 C -1
}

# Android
# function aupdate() {
#      cd /tmp/1
#     if [ -e tieba-release.apk  ]; then
#         rm tieba-release.apk
#     fi
#     wget "http://ci.tieba.baidu.com/view/TBPP_Android/job/FC_Native_Android_Build_ICODE/""$1""/artifact/gen_apks/tieba-release.apk"
#     adb install -rg tieba-release.apk
# }

function bssync() {
    local from
    local to
    if [ "$#" -eq 1 ]; then
        from='.'
        to=${1}
    elif [ "$# -eq 2"]; then
        from=${1}
        to=${2}
    else
        echo 'Usage: bssync ${destination} or bssync ${source} ${destination}'
        return 1
    fi
    rsync -avz --delete --exclude=.git --exclude-from="$(git -C ${from} ls-files --exclude-standard -oi --directory > /tmp/excludes; echo /tmp/excludes)" ${from} ${to}
}

_fzf_complete_make() {
  _fzf_complete "--multi --reverse" "$@" < <(
    grep '^[^\.][-a-zA-Z\.0-9_\/]*:' ./Makefile | sed 's/:.*//g' | uniq
  )
}
