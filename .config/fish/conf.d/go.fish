setenv GO111MODULE "on"
setenv GOPATH "$XDG_DATA_HOME/go"
setenv GOBIN $USER_BIN
setenv GOROOT $GOBIN

lib::check_cmd_exists go
