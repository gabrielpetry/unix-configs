# # lazy load all node bins
# if ! command -v node > /dev/null; then
#     #
#     string=""
#     eval_cache="/tmp/eval.cache"
#     if test -f $eval_cache && find /private/tmp -name 'eval.cache' -type f -mmin +360 > /dev/null; then
#         string="$(cat "$eval_cache")"
#     else
#         for p in nvm $(fd . $HOME/.nvm/versions/node/*/bin --max-depth 1 --exec basename {} \; | sort | uniq); do
#             string="$string $newline $p() { unset -f $p; try_nvm; $p \$@} "
#             echo "$string" >> $eval_cache
#         done
#     fi
#     # eval "$string"
#     source "$eval_cache"
# fi
if ! command -v node > /dev/null; then
    for p in nvm $(fd . $HOME/.nvm/versions/node/*/bin --max-depth 1 --exec basename {} \; | sort | uniq); do
        echo
        echo "$p() { unset -f $p; try_nvm; $p \$@} "
    done
    echo ""
fi
