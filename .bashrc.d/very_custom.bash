#!/bin/false
# no-op hashbang - meant to be sourced in bashrc/bash_profile/etc....

## UNCOMMENT THESE TO SET DIFFERENT DEFAULTS
#export DEFAULT_JAVA_VERSION="1.8.0_20"
#export FLYWAY_HOME="${HOME}/installed_tools/flyway-3.1"

echoerr() { cat <<< "ERROR: $@" 1>&2; }

set_aws_keys() {
  local AWS_PROFILE=${AWS_PROFILE:-default}
  local CREDENTIALS_FILE PYTHON_VERSION PYTHON_PROGRAM KEYS
  if [[ -f "${HOME}/.aws/credentials" ]]; then 
    CREDENTIALS_FILE="${HOME}/.aws/credentials"
  elif [[ -f "${HOME}/.aws/config" ]]; then 
    CREDENTIALS_FILE="${HOME}/.aws/config"
  else
    echoerr "AWS Credentials could not be found!"
  fi
  if ! which python > /dev/null 2>&1; then echoerr "Python not found in path!"; fi
  PYTHON_VERSION=$(python --version 2>&1 | cut -d\  -f 2 | cut -d. -f 1)
  if [[ "${PYTHON_VERSION}" = "3" ]]; then 
    read -d '' -r PYTHON_PROGRAM <<EOF
print "Python 3 not currently supported"
EOF
  else
    read -d '' -r PYTHON_PROGRAM <<EOF
import ConfigParser
config = ConfigParser.ConfigParser()
config.read("${CREDENTIALS_FILE}")
config = dict(config.items("${AWS_PROFILE}"))
print config["aws_access_key_id"], ' ', config["aws_secret_access_key"]
EOF
  fi
  KEYS=$(python -c "${PYTHON_PROGRAM}")
  if [[ "${#KEYS}" == "0" ]]; then echoerr "Didn't find any keys for profile ${AWS_PROFILE} in ${CREDENTIALS_FILE}"; fi
  export AWS_ACCESS_KEY_ID=$(echo $KEYS | cut -d\  -f 1)
  export AWS_SECRET_ACCESS_KEY=$(echo $KEYS | cut -d\  -f 2)
}

setup_flyway() {
  local FLYWAY_HOME="${FLYWAY_HOME:-${HOME}/installed_tools/flyway-3.1}"
  if ! [[ -d "${FLYWAY_HOME}" ]]; then 
    echoerr "Flyway folder not found @ ${FLYWAY_HOME}" <&2
  else
    export PATH=${PATH}:${FLYWAY_HOME}
    export FLYWAY_HOME
  fi
}

setup_bash_completion() {
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    source $(brew --prefix)/etc/bash_completion
  elif [ -f /opt/local/etc/bash_completion ]; then
    source /opt/local/etc/bash_completion
  fi
}

jdkls() { /usr/libexec/java_home -V 2>&1 | grep 'x86_64' | cut -d, -f 1 | tr -d ' ' ; }

select_jdk() {
  local SELECTED_JVM
  if [[ "$#" -eq "0" ]]; then
    setup_path # Redo the PATH if this is called on the CLI
    select SELECTED_JVM in $(jdkls); do echo "Selected ${SELECTED_JVM}"; break; done
    export DEFAULT_JAVA_VERSION="${SELECTED_JVM}"
  else
    SELECTED_JVM="${1}"
  fi
  export JAVA_HOME="$(/usr/libexec/java_home -v ${SELECTED_JVM} 2>&1)" 
  if grep 'Unable to find any JVMs matching version' <<< "$JAVA_HOME" > /dev/null 2>&1; then 
    echoerr "${SELECTED_JVM} Does not match an installed JVM; setting to whatever java_home returns"
    export JAVA_HOME="$(/usr/libexec/java_home)"
  fi
  export PATH=${JAVA_HOME}/bin:${PATH}
  echo "JAVA_HOME set to ${JAVA_HOME}"
  java -version
}

setup_path() {
  PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin" # Homebrew installed files on the head of the PATH
  which port > /dev/null 2>&1 && PATH="/opt/local/bin:/opt/local/sbin:${PATH}" # If MacPorts is installed, its executables override all others...
  [[ -d "${HOME}/bin" ]] && PATH="${HOME}/bin:${PATH}"
  setup_flyway
  [[ -s "${HOME}/.rvm/scripts/rvm" ]] && source "${HOME}/.rvm/scripts/rvm" # Source RVM last; mangles the hell out of the head of the $PATH
  export PATH
}

blah() { ls -m "$@"; }

# logging into AWS, use like: aws 1.20
ec2() { ssh 10.0.$1; }

re() {
  case "${1}" in
    # re f string
    f) find . -iname "*${2}*" ;;
    scpto)    scp "${2}" "${3}":"${4}"    ;;
    scpfrom)  scp "${2}":"${3}" "${4}"    ;;
    scpfromr) scp -r "${2}":"${3}" "${4}" ;;
    start) case "${2}" in
        j)     ${HOME}/jetty/bin/jetty.sh start ;;
        e)     ${HOME}/Downloads/elasticsearch-1.2.1/bin/elasticsearch ;;
        bbems) ${HOME}/octrun/ems/bin/emsctl_debug start ;;
        bbama) ${HOME}/appservers/apache-tomcat-7.0.19/bin/debug.sh ;;
        redis) ${HOME}/redis-2.8.9/src/redis-server ;;
        memcached) /usr/local/opt/memcached/bin/memcached ;;
        *) echoerr "Unknown second arg: ${2}" ;;
      esac ;;
    stop) case "${2}" in
        j)     ${HOME}/jetty/bin/jetty.sh stop ;;
        bbems) ${HOME}/octrun/ems/bin/emsctl_debug stop ;;
        bbama) ${HOME}/appservers/apache-tomcat-7.0.19/bin/shutdown.sh ;;
        *) echoerr "Unknown second arg: ${2}" ;;
      esac ;;
    unzipto) sudo mkdir -p "${3}" && sudo chmod 777 "${3}" && unzip "${2}" -d "${3}" ;; #Wicked dirty
    jdbc) case "${2}" in
        l) rm -f /configs/jdbc.properties && ln -s /configs/jdbc.properties.localhost /configs/jdbc.properties ;;
        r) rm -f /configs/jdbc.properties && ln -s /configs/jdbc.properties.realdb    /configs/jdbc.properties ;;
        *) echoerr "Unknown second arg: ${2}" ;;
      esac ;;
    elastic) case "${2}" in
        l) rm -f /configs/elasticsearch.properties && ln -s /configs/elasticsearch.properties.localhost   /configs/elasticsearch.properties ;;
        r) rm -f /configs/elasticsearch.properties && ln -s /configs/elasticsearch.properties.realcluster /configs/elasticsearch.properties ;;
        *) echoerr "Unknown second arg: ${2}" ;;
      esac ;;
    g) case "${2}" in
        bbems) pushd ${HOME}/octrun/ems/bin/ ;;
        bbama) pushd ${HOME}/appservers/apache-tomcat-7.0.19/bin ;;
        repo)  pushd ${HOME}/repo ;;
        bbrepo) pushd ${HOME}/repo/boxbe ;;
        ngrepo) pushd ${HOME}/repo/analyst-ng/source ;;
        *) echoerr "Unknown second arg: ${2}" ;;
      esac ;;
    w) case "${2}" in
        ng) pushd ${HOME}/repo/analyst-ng/source/webapp-analyst-ng/src/main/webapp && grunt watch ;;
        admin) pushd ${HOME}/repo/analyst-ng/source/webapp-admin-ng/src/main/webapp && grunt watch ;;
        *) echoerr "Unknown second arg: ${2}" ;;
      esac ;;
    boxbetail) ${HOME}/installed_tools/boxbetail.sh ;;
    eclipse) pushd ${HOME}/Desktop/eclipse4.4 && open -n Eclipse.app ;;
    b) case "${2}" in
        bb) pushd ${HOME}/repo/boxbe/common/octlibs
            ant clean build package 
            popd; pushd ${HOME}/repo/boxbe 
            ant clean build deploy 
            pushd ems 
            ant deploy
            popd; pushd ama
            ant deploy
            popd; pushd common/webroot
            ant deploy
            ;;
        ng) pushd ${HOME}/repo/analyst-ng/source
            buildr test=no
            pushd webapp-analyst-ng
            buildr package test=no
            ;;
        a) pushd ${HOME}/repo/analyst-ng/source
           buildr test=no
           pushd webapp-admin-ng
           buildr package test=no
           ;;
        api) pushd ${HOME}/repo/analyst-ng/source
            buildr test=no
            pushd webapp-api-analyst
            buildr package test=no
            pushd target 
            sudo mkdir exploded && sudo chmod 777 exploded #evil
            unzip *.war -d exploded
            ;;
        apiclassic) pushd ${HOME}/repo/analyst-ng/source
                    buildr test=no && cd webapp-api-classic && buildr package test=no
                    ;;
        *) echoerr "Unknown second arg: ${2}" ;;
      esac ;;
    "fi") grep -r "${2}" . ;;
    filecount) ls -l | wc -l ;;
    *) echoerr "Unknown arg ${1}" ;;
  esac
}
