# Conform bash files to XDG standard.
_confdir="${HOME}/.config/bash"
if [[ -d "$_confdir" ]] && [[ "$0" = "bash" ]]; then
    touch "${_confdir}/bash_profile"
    . "${_confdir}/bash_profile"
    . "${_confdir}/bashrc"
    HISTFILE="${_confdir}/bash_history"
fi
unset _confdir

