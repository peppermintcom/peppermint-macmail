ROOT=$(shell pwd)
DMG_VOLUME_NAME="PeppermintMail"

UNCOMMITED_CHANGES=$(shell git status --porcelain)

build/Peppermint.mailbundle: build
	ifneq ($(words $(UNCOMMITED_CHANGES)), 0)
		$(error You have uncommited changes)
	endif
	cd PeppermintMail && xcodebuild CONFIGURATION_BUILD_DIR="$(ROOT)/build"

build:
	mkdir $@

clean:
	cd PeppermintMail && xcodebuild clean
	rm -rf build
