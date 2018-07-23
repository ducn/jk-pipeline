#!/usr/bin/env bash
# create jenkins job with template pipeline
#
### ex:  $ ./cli_client_build_job.sh "http://ec2-54-179-171-235.ap-southeast-1.compute.amazonaws.com:8080" "webhook_test"
# * $1: jenkins server url,         ex:   "http://ec2-54-179-171-235.ap-southeast-1.compute.amazonaws.com:8080"
# * $2: job name,                   ex:   "webhook_test"
###
# * : required

print_help() {
    echo "./cli_client_create_job.sh <jenkins_server_url> <job_name>"
    echo "jenkins server url,         ex:   \"http://ec2-54-179-171-235.ap-southeast-1.compute.amazonaws.com:8080\""
    echo "job name,                   ex:   \"webhook_test\""
}

# check number of arguments
if [[ "$#" -ne 2 ]]; then
    echo "Require 2 parameters"
    print_help
    exit 1
fi

# build job
java -jar $HOME/jenkins-cli.jar -s $1 -auth cinnamon:cinnamon build $2
