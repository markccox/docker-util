#!/bin/bash

usage () {
  echo "USAGE: ${0} -t|--tag <TAG> -m|--module <MODULE>"
}

while :; do

  case "${1}" in

    # Take -r or --role parameter with argument for services to be started.
    -r|--role)
      ROLE="${2}"
      shift 2
    ;;

    # Take -i or --instance parameter with argument for unique instance of the
    # service role to be performed by the host.
    -i|--instance)
      INSTANCE="${2}"
      shift 2
    ;;

    # Unrecognized parameter
    *)
      echo "1 is $1"
      usage
      exit
    ;;
  esac

  # No more parameters left
  if [ "${1}X" == "X" ]; then
    break
  fi

done

apt update

case "${ROLE}" in

  # Postgres
  p|postgres)
    hostname postgres${INSTANCE}
    cat << EOF | \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install postgresql postgresql-contrib
$(sleep 30)
2
$(sleep 30)
106
EOF

    /etc/init.d/postgresql start
  ;;

  # Apache service
  a|apache)
    hostname apache${INSTANCE}
    apt -y install apache2
    /etc/init.d/apache2 start
  ;;

  # Tomcat service
  t|tomcat)
    hostname tomcat${INSTANCE}
    apt -y install default-jdk
    apt -y install curl
    groupadd tomcat
    useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
    mkdir /opt/tomcat
    cd /opt/tomcat
    curl -O https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.78/bin/apache-tomcat-9.0.78.tar.gz
    tar xzvf *gz
    rm *gz
    #/etc/init.d/tomcat start
  ;;

esac

/etc/init.d/ssh start

/bin/bash
