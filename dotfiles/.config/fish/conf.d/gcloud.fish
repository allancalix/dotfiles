set GCLOUD_SDK_PATH "$HOME/bin/google-cloud-sdk"

# Install gcloud toolchain.
if test -d $GCLOUD_SDK_PATH
  source "$GCLOUD_SDK_PATH/path.fish.inc"
end
