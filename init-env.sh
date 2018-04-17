#!/usr/bin/env #!/usr/bin/env bash

#defaults
export SCALE=5
export HS2=localhost:10000
export DRUID_META_HOST=localhost
# Should be configured by Ambari (in Hive) when Druid is installed.
#export DRUID_META_USERNAME=${4:-druid}
#export DRUID_META_PASSWORD=${5:-password}
export HIVE_USER=${USER}
export HIVE_PASSWORD_FILE=.hive_password

if [ -f .druid-env.props ]; then
  echo "Found props file."
  export $(cat .druid-env.props | grep -v ^# | xargs)
else
  echo "No props file found, checking cli input."
  while [ $# -gt 0 ]; do
    case "$1" in
      --scale)
        shift
        export SCALE=$1
        shift
        ;;
      --hive-url)
        shift
        export HS2=$1
        shift
        ;;
      --hive-user)
        shift
        export HIVE_USER=$1
        shift
        ;;
      --hive-password-file)
        shift
        export HIVE_PASSWORD_FILE=$1
        shift
        ;;
      --druid-meta-host)
        shift
        export DRUID_META_HOST=$1
        shift
        ;;
      # --druid-meta-username)
      #   shift
      #   export DRUID_META_USERNAME=$1
      #   shift
      #   ;;
      # --druid-meta-password)
      #   shift
      #   export DRUID_META_PASSWORD=$1
      #   shift
      #   ;;
      *)
        break
        ;;
    esac
  done
fi
