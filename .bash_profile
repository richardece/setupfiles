#originally from 
# https://github.com/w3cj/dotfiles/

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
bldgrn='\e[1;32m' # Bold Green
bldpur='\e[1;35m' # Bold Purple
txtrst='\e[0m'    # Text Reset

emojis=("👾" "🌐" "🎲" "🌍" "🐉" "🌵")

EMOJI=${emojis[$RANDOM % ${#emojis[@]} ]}

print_before_the_prompt () {
    dir=$PWD
    home=$HOME
    #dir=${dir/"$HOME"/"~"}
    printf "\n$txtgrn%s $bldgrn%s \n$txtrst" "$dir" "$(vcprompt)"
}

PROMPT_COMMAND=print_before_the_prompt
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
PS1="$ "
PS2="  "

#alias
alias kraken="open -na 'GitKraken' --args -p $(pwd)"
#This command only opens pwd. How to add args so that it can open any directory?

#For linux matlab
#alias matlab='/usr/local/Polyspace/R2020a/bin/matlab'


export PATH="/usr/local/opt/qt@5/bin:$PATH"