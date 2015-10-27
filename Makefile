ROOT=$(shell pwd)
DMG_VOLUME_NAME="PeppermintMail"

UNCOMMITED_CHANGES=$(shell git status --porcelain)

build/Peppermint.mailbundle: build
	$(foreach var,$(UNCOMMITED_CHANGES),$(error You have uncommited changes))
	cd PeppermintMail && xcodebuild CONFIGURATION_BUILD_DIR="$(ROOT)/build"

build:
	mkdir $@

clean:
	cd PeppermintMail && xcodebuild clean
	rm -rf build
