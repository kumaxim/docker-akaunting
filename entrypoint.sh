#!/bin/bash -e
source ${AKAUNTING_RUNTIME_DIR}/functions

[[ $DEBUG == true ]] && set -x

case ${1} in
  app:akaunting|app:init|artisan)

  if [[ ! -f "${AKAUNTING_INSTALL_DIR}/artisan" ]]; then
    install_akaunting
    initialize_system
    configure_nginx
  fi

  case ${1} in
    app:init)
      initialize_system
      configure_nginx
    ;;
    app:akaunting)
      configure_akaunting
      echo "Starting Akaunting php-fpm..."
      exec $(which php-fpm) -F
      ;;
    artisan)
      exec php $@
      ;;
  esac
  ;;
  app:help)
    echo "Available options:"
    echo " artisan              - Launch the artisan command"
    echo " app:akaunting        - Starts the Akaunting php-fpm server (default)"
    echo " app:help             - Displays the help"
    echo " [command]            - Execute the specified command, eg. bash."
    ;;
  *)
    exec "$@"
    ;;
esac
