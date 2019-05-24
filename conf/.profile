############ iterm2 #######
# key bindings
#bindkey "\e[1~" beginning-of-line
#bindkey "\e[4~" end-of-line
# CTRL+q
stty start undef
stty stop undef
bindkey \^U backward-kill-line

###############
#export
export ENV_MODE=dev
export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'
export CLICOLOR="xterm-color"
export PATH=/usr/local/opt/python/libexec/bin:$PATH:$HOME/www/a/bin:~/bin
export GNUTERM=qt
export PROMPT='${ret_status}%{$fg_bold[green]%}%p%{$fg[cyan]%}%C$ %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%}%{$reset_color%}'$'\n$ '
#export JAVA_HOME="$(/usr/libexec/java_home -v 1.7)"
export PIP_FORMAT=columns

ulimit -n 1000

# alias
export EDITOR="nvim"
alias vi='nvim'
alias cp='cp -i'
alias svnst='svn st'
alias l='ls -lah'
alias code1='/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code'

# python
alias py='ipython3'
alias p='python'
export PYTHONPATH=.

# docker
alias drmi='docker rmi $( docker images --filter "dangling=true" -q --no-trunc)'

# go
# goenv
export GOROOT=/usr/local/Cellar/go@1.11/1.11.6/libexec
export GO111MODULE=on 
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin

# brew
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
#export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles

#git
#sh ~/.git.bash

# git complete
#tree /usr/local/etc/bash_completion.d
#adb-completion.bash git-completion.bash git-prompt.sh

# git command
alias gitup='git submodule init && git submodule update'
alias ga.='git add .'
function lllllllllzrmv(){
    mv $2 $1;
}

function gcap(){
	git commit -am $1;
    if test $? != 0;then
        return
    fi

    if git remote | grep '\w';then
        if git remote ; then
            cd $(git rev-parse --show-toplevel)
            subdirs=(b vue )
            oridir=$(pwd)
            echo "check oridir $oridir"
            for subdir in "${subdirs[@]}"; do
                echo "check subdir $subdir"
                test -d $subdir && cd $subdir;
                if test $? = 0;then
                    echo git push $subdir;
                    #git add .
                    #git commit -am "msg:$1"
                    #git remote | xargs -L1 git push
                    cd $oridir
                fi
            done
        fi
    elif git svn info | grep '\w';then
        echo git svn dcommit;
        git svn rebase;
        git svn dcommit;
    fi
}

# grep
unset GREP_OPTIONS
alias grep='grep --color=auto --exclude-dir=.cvs --exclude-dir=.git --exclude-dir=.hg --exclude-dir=.svn'
mcd(){ mkdir -p $@; cd $1}
alias rgrep='grep -rn -F'
rgrep.(){ grep -rn $@ .}

# gbk
function iconvgbk(){
	if test $# -gt 0; then
		test -f $1 && iconv -c -f gbk -t utf-8  $1 > ~/tmp.txt && mv ~/tmp.txt $1 && echo "Successfully convert $file!";
	fi
}
function uniqfile(){
	if test $# -gt 0; then
		echo "waiting";
		sort $1 | uniq > ~/tmp.txt && mv ~/tmp.txt $1 && echo 'succ'
	fi
}

# loop shell command
function loop(){
	while true;do
		#printf "\r%s" "`$*`";
		printf "\n%s" "`$@`";
		sleep 1;
	done
}

# mda
function mda (){
        mkdir -p $1
        sudo chmod a+rwx $1
}

#alias for cnpm
alias npm="npm --registry=https://registry.npm.taobao.org \
  --cache=$HOME/.npm/.cache/cnpm \
  --disturl=https://npm.taobao.org/dist \
  --userconfig=$HOME/.cnpmrc"

# z.lua
#eval "$(lua ~/conf/z.lua --init zsh)"

[ -f ~/.private ] && source ~/.private
[ -f ~/.wk ] && source ~/.wk
