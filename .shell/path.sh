# Setup ${PATH}

# Speciliaze if needed per OS.
#
# if [ ${IS_LINUX} ]; then
#   export PATH="${PATH}:/foo/bar"
# elif [ ${IS_MACOS} ]; then
#   export PATH="${PATH}:/foo/bar/baz"
# fi

ORDERED_PATHS=(
	"${HOME}/bin"
	"${HOME}/lib"
	"${HOME}/.rvm/bin"
	"${HOME}/.local/bin"
	"${HOME}/venv/bin"
	"${HOME}/.antigravity/antigravity/bin"
	# Specific to MacOS
	"/Applications/Sublime Text.app/Contents/SharedSupport/bin"
	# Add original PATH
	"${PATH}"
)

OLD_IFS=${IFS}
IFS=:
PATH_TO_EXPORT="${ORDERED_PATHS[*]}"
IFS=${OLD_IFS}

export PATH="${PATH_TO_EXPORT}"
