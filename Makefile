ROOT=$(shell pwd)
DMG_VOLUME_NAME="PeppermintMail"

UNCOMMITED_CHANGES=$(shell git status --porcelain)

build/Peppermint.mailbundle: build
	@echo $(words $(UNCOMMITED_CHANGES))
	ifneq(,$(words $(UNCOMMITED_CHANGES)))
		$(error Abort)
	endif
	cd PeppermintMail && xcodebuild CONFIGURATION_BUILD_DIR="$(ROOT)/build"

build:
	mkdir $@

clean:
	cd PeppermintMail && xcodebuild clean
	rm -rf build
