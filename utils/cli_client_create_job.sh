#!/usr/bin/env bash
# create jenkins job with template pipeline
#
### ex:  $ ./cli_client_create_job.sh "http://ec2-54-179-171-235.ap-southeast-1.compute.amazonaws.com:8080" "webhook_test" "https://github.com/robinson0812/webhook_test.git"
# * $1: jenkins server url,         ex:   "http://ec2-54-179-171-235.ap-southeast-1.compute.amazonaws.com:8080"
# * $2: job name,                   ex:   "webhook_test"
# * $3: project scm url,            ex:   "https://github.com/robinson0812/webhook_test.git"
#   $4: project scm display name,   ex:   "Webhook Test"
#   $5: pipeline library,           ex:   "cinnamon-shared-pipeline-library"
#   $6: pipeline library version,   ex:   "master"
#   $7: pipeline template,          ex:   "cinnamonStandardPipeline"
###
# * : required

print_help() {
    echo "./cli_client_create_job.sh <jenkins_server_url> <job_name> <project_scm_url> [project_scm_display_name] [pipeline_library] [pipeline_library_version] [pipeline_template]"
    echo "jenkins server url,         ex:   \"http://ec2-54-179-171-235.ap-southeast-1.compute.amazonaws.com:8080\""
    echo "job name,                   ex:   \"webhook_test\""
    echo "project scm url,            ex:   \"https://github.com/robinson0812/webhook_test.git\""
    echo "project scm display name,   ex:   \"Webhook Test\""
    echo "pipeline library,           ex:   \"cinnamon-shared-pipeline-library\""
    echo "pipeline library version,   ex:   \"master\""
    echo "pipeline template,          ex:   \"cinnamonStandardPipeline\""
}

# check number of arguments
if [[ "$#" -lt 3 ]]; then
    echo "Require at least 3 parameter"
    print_help
    exit 1
fi

# create template
export scm_url=$3
export scm_display_name=${4-"Default SCM Display Name"}
export pipeline_library=${5-"cinnamon-shared-pipeline-library"}
export pipeline_library_branch=${6-"master"}
export pipeline_template=${7-"cinnamonStandardPipeline"}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
bash $DIR/templater.sh cinnamon_pipeline_template.xml | java -jar ~/jenkins-cli.jar -s $1 -auth admin:admin123 create-job $2

# build job
java -jar ~/jenkins-cli.jar -s $1 -auth admin:admin123 build $2
