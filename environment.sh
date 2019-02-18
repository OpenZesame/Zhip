read -p "This will replace your current pasteboard. Continue? [y/n]" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	macos=$(defaults read loginwindow SystemVersionStampAsString | cat -) &&
	xcodebuild_version=$(/usr/bin/xcodebuild -version | grep Xcode) &&
	xcodebuild_build=$(/usr/bin/xcodebuild -version | grep Build) &&
	xcodeselectpath=$(xcode-select -p | cat -) &&
	rubyversion=$(ruby --version | cat -) &&
	whichruby=$(which ruby | cat -) &&
	bundleversion=$(bundle --version | cat -) &&
	i="macOS version: ${macos}\n"
	i="${i}Xcode-select path: '${xcodeselectpath}\n"
	i="${i}Xcode: ${xcodebuild_version} (${xcodebuild_build})\n"
	i="${i}Ruby version: ${rubyversion} (at '${whichruby}')\n"
	i="${i}Bundler: ${bundleversion}"
	echo "${i}" | pbcopy
	echo "Your pasteboard now contains debug info, paste it on Github"
fi
