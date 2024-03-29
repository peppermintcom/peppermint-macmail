ROOT=$(shell pwd)
DMG_VOLUME_NAME="PeppermintMail"

UNCOMMITED_CHANGES=$(shell git status --porcelain)
CURRENT_PROJECT_VERSION=$(shell cd PeppermintMail && agvtool vers -terse)
MARKETING_VERSION=$(shell cd PeppermintMail && agvtool mvers -terse | grep Peppermint/Info.plist | awk -F'=' '{print $$2}')

build/Peppermint.mailbundle: build .git
	$(foreach VAR, $(UNCOMMITED_CHANGES), $(error You have changes uncommited))
	# build the product
	cd PeppermintMail && xcodebuild CONFIGURATION_BUILD_DIR="$(ROOT)/build"
	# synchronize version of pkg with mvers and build package
	packagesutil --file Installer/Peppermint.pkgproj set package com.xgenmobile.pkg.peppermint version $(MARKETING_VERSION)
	packagesbuild -F build Installer/Peppermint.pkgproj
	mv Installer/build/Peppermint.pkg build/Peppermint-$(MARKETING_VERSION)-$(CURRENT_PROJECT_VERSION).pkg
	# update version in VCS
	cd PeppermintMail && agvtool bump -all
	git add .
	git commit -m "Version $(CURRENT_PROJECT_VERSION)"

devbuild:
	# build the product
	cd PeppermintMail && xcodebuild CONFIGURATION_BUILD_DIR="$(ROOT)/build"
	# synchronize version of pkg with mvers and build package
	packagesutil --file Installer/Peppermint.pkgproj set package com.xgenmobile.pkg.peppermint version "dev"
	packagesbuild -F build Installer/Peppermint.pkgproj
	mv Installer/build/Peppermint.pkg build/Peppermint-$(MARKETING_VERSION)-$(CURRENT_PROJECT_VERSION).pkg

build:
	mkdir $@

clean:
	cd PeppermintMail && xcodebuild clean
	rm -rf build
