#!/usr/bin/env bash
cd ..
pwd
flutter packages pub run build_runner build --delete-conflicting-outputs
