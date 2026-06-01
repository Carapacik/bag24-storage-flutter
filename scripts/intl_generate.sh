#!/bin/sh

# Generate l10n files
dart pub global activate intl_utils
dart pub global run intl_utils:generate
