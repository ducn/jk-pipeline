# damato-ci

## CI

### Setup and config Jenkins

#### Install approaches

Requirements:
- OS: Ubuntu 16.04 or newer


Setup using docker on Ubuntu system:
  ```commandline
  sudo bash jenkins_install_docker.sh
  ```

#### Standardize Pipeline

6 stages:
 - Prepare build environment
   - Clone/Pull project from scm url
   - Read `cli-config.json` in project source tree
   - Create docker volume for job
   - Pull/Update ci tools docker image
   - Pull/Update base docker image
 - Download model to job's volume
 - Download dataset to job's volume
 - Prepare run environment inside base image
 - Run evaluation command
 - Save report
 
#### Developer Steps
To create job:
 - In source code, specify `cli-config.json` file, for ex:
 ```
 {
  "model": {
   "version": "0.0.1",
   "dataset_ids": ["0123", "1b34", "333"],
   "model_file_ids": ["1mD_MAD4SSXjuF0pPapaj3khxX6wICZwh", "1BOgYnnVcCvwoB6L8F0CW2aBb151TsHXr"]
  },
  "build": {
   "base_image": "bachngocson/python3.6",	
   "environment_preparation": [
    "cat /etc/os-release && env && ls -la",
    "ls -la /root && ls -la /root/project_source_code",
    "pip3 install -r requirements.txt"
   ],
   "main": "python model.py"
  }
 }
 ```
 - In Web UI, specify folling information (\* means required):
   - \* Jenkins server url
   - \* Job name
   - \* Github url
   -    Github Display name
   -    Pipeline library
   -    Pipeline version
   -    Pipeline template
   
   The Web Server then calls bash script `cli_client_create_job.sh` with above parameters to create job and trigger first build
   
 - In Web UI, if the user need to re run the build, specify folling information (\* means required):
   - \* Jenkins server url
   - \* Job name
   
   The Web Server then calls bash script `cli_client_build_job.sh` with above parameters to trigger a new build
   
 - In Project's Github Settings page, add webhook URL: `Jenkins_server_url/github-webhook/` to trigger build whenever developer push code to Github.
 - In Pipeline's Github Settings page, add webhook URL: `Jenkins_server_url/github-webhook/` to trigger build whenever the pipeline definition changes

#### Google Drive interaction
We'll use [gdrive](https://github.com/prasmussen/gdrive) for interacting with Google Drive.
```
gdrive usage:

gdrive [global] list [options]                                 List files
gdrive [global] download [options] <fileId>                    Download file or directory
gdrive [global] download query [options] <query>               Download all files and directories matching query
gdrive [global] upload [options] <path>                        Upload file or directory
gdrive [global] upload - [options] <name>                      Upload file from stdin
gdrive [global] update [options] <fileId> <path>               Update file, this creates a new revision of the file
gdrive [global] info [options] <fileId>                        Show file info
gdrive [global] mkdir [options] <name>                         Create directory
gdrive [global] share [options] <fileId>                       Share file or directory
gdrive [global] share list <fileId>                            List files permissions
gdrive [global] share revoke <fileId> <permissionId>           Revoke permission
gdrive [global] delete [options] <fileId>                      Delete file or directory
gdrive [global] sync list [options]                            List all syncable directories on drive
gdrive [global] sync content [options] <fileId>                List content of syncable directory
gdrive [global] sync download [options] <fileId> <path>        Sync drive directory to local directory
gdrive [global] sync upload [options] <path> <fileId>          Sync local directory to drive
gdrive [global] changes [options]                              List file changes
gdrive [global] revision list [options] <fileId>               List file revisions
gdrive [global] revision download [options] <fileId> <revId>   Download revision
gdrive [global] revision delete <fileId> <revId>               Delete file revision
gdrive [global] import [options] <path>                        Upload and convert file to a google document, see 'about import' for available conversions
gdrive [global] export [options] <fileId>                      Export a google document
gdrive [global] about [options]                                Google drive metadata, quota usage
gdrive [global] about import                                   Show supported import formats
gdrive [global] about export                                   Show supported export formats
gdrive version                                                 Print application version
gdrive help                                                    Print help
gdrive help <command>                                          Print command help
gdrive help <command> <subcommand>                             Print subcommand help
```

So, to download model, we use `sh "gdrive-linux-x64 download -r -f --path /data/model/ ${model_file_id}"` in Jenkins pipeline.



