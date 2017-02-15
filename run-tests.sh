#!/bin/sh

PROJECT="SwiftyTasks.xcodeproj"
SCHEME="SwiftyTasks"
DEVICE="$(instruments -s devices | grep 'iPhone 7' | grep '10\.' | sed 's/.*\[\([A-Z0-9-]*\)\].*/\1/g' | head -1)"

xcodebuild test -project "$PROJECT" -scheme "$SCHEME" -sdk iphonesimulator -destination "id=$DEVICE" ONLY_ACTIVE_ARCH=NO
