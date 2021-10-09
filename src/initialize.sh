# Code here runs inside the initialize() function
# Use it for anything that you need to run before any other function, like
# setting environment vairables:
# CONFIG_FILE=settings.ini

# TODO set -eu -o pipefail # Exit on error, no unset variables, failure in pipeline is error

# Use this function internally to call ourself, so it'll work no matter how the script is installed.
git_draft() {
	"$0" "$@"
}
