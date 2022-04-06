#! /bin/bash

flutter clean && \
flutter build web && \
firebase login && \
firebase deploy
