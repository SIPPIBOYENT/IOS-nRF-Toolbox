# This workflow will build a Swift project
# For more information see: https://docs.github.com/en/actions/automating-builds-and-tests/building-and-testing-swift

name: Swift

on:
  push:
    branches: [ "master" ]
  pull_request:
    branches: [ "master" ]

jobs:
  build:

    runs-on: macos-latest

    steps:
    - uses: actions/checkout@v4
    - name: Build
      run: swift build -v
    - name: Run tests
      run: swift test -v
