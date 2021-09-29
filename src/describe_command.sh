if [[ "$(run active-is-empty)" == "y" ]]; then
	echo "empty draft"
else
	echo "draft" # TODO provide more detail
fi
