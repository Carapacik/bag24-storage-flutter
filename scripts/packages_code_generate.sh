#!/bin/sh

cd ./packages/rest_client/ || exit

# Run build_runner to generate code
dart run build_runner build -d

# Exit with success status (0).
exit 0
