SWIFTC=swiftc
UNAME=$(shell uname)

ifeq ($(UNAME), Darwin)
XCODE=$(shell xcode-select -p)
SDK=$(XCODE)/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk
TARGET=x86_64-apple-macosx10.10
SWIFTC=swiftc -target $(TARGET) -sdk $(SDK) -Xlinker -all_load
endif

BUILD_DIR=.build/debug
#BUILD_OPTS=-v

LIBS=$(wildcard $(BUILD_DIR)/*.a)
LDFLAGS=$(foreach lib,$(LIBS),-Xlinker $(lib))

.PHONY: all clean lib test

all: lib
	
lib:
	swift build $(BUILD_OPTS)

test: lib
	cd Spectre && swift build $(BUILD_OPTS)
	$(SWIFTC) -o $(BUILD_DIR)/test-runner Tests/*.swift -I$(BUILD_DIR) \
		-ISpectre/$(BUILD_DIR) -Xlinker Spectre/$(BUILD_DIR)/Spectre.a \
		$(LDFLAGS)
	./$(BUILD_DIR)/test-runner
	@rm -f ./$(BUILD_DIR)/test-runner
	./$(BUILD_DIR)/chocolat-cli Tests/Fixtures/Package.swift

clean:
	swift build --clean
	rm -rf ./Packages
	cd Spectre && swift build --clean
