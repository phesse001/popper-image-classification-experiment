# Reproducible Experiment
By treating code and results related to a research papaer as a software project we can improve the reproducibility of results by decomposing the workflow into steps that can be automated by devops tools.

## Workflow
This particular example uses an image classification implementation and looks at different inference speeds of the model based on the number of threads in the system.
The steps of the workflow are as follows:
1. Provision infrastructure
2. Configure infrastructure
3. Run experiment on infrastructure
4. Visualize results

This workflow will use [Popper](https://github.com/getpopper/popper) to provide a common interface to run our experimental tasks. Each of these tasks will be run in a container. First we will use a docker container with terraform installed to provision nodes. Then we will use a docker container with ansible installed to configure these containers and run the experiment. Finally we will use a docker container with jupyter notebooks installed to see the results from the experiment.

## wf.yml file
```yaml
steps:
- id: generate-keys
  uses: './ssh'
  runs: ['ssh-keygen', '-b', '2048', '-t', 'rsa', '-f', '/workspace/.ssh/aws_key', '-q', '-P', '']
  dir: /workspace/.ssh

- id: infrastructure-provisioning
  uses: './host'
  runs: [bash, -uexc]
  args: 
  - |
    terraform init
    terraform apply -auto-approve -var="credentials_file=<path to aws credentials file>" -var="profile=<profile name>"
  options:
    volumes:
      - <path to .aws directory>:/root/.aws
      - <path to root of this repository>/terraform:/workspace
      - <path to root of this repository>/.ssh:/root/.ssh

- id: create-hostfile
  uses: 'sh'
  runs: ["python3", "create_hostfile.py"]

- id: install-packages
  uses: './ansible'
  runs: [bash, -uexc]
  dir: /root/home/ansible/
  args:
  - |
    ansible-playbook --private-key /root/.ssh/aws_key -i hosts packages.yml
  options:
    volumes:
      - <path to root of this repository>/.ssh:/root/.ssh
 
- id: run-experiment
  uses: './ansible'
  runs: [bash, -uexc]
  dir: /root/home/ansible/
  args:
  - |
    ansible-playbook --private-key /root/.ssh/aws_key -i hosts experiment.yml
  options:
    volumes:
      - <path to root of this repository>/.ssh:/root/.ssh/aws

- id: visualize-results
  uses: docker://jupyter/base-notebook
```

This workflow automates the following actions: generating ssh keys, provisioning cloud infrastructure with aws, configuring aws instance, pulling and running experiment on aws instance, and visualizing results. The only dependencies to running this experiment on any host are `Docker`, `Popper`, and `aws`.

Instructions on how to install `Docker` can be found [here](https://docs.docker.com/get-docker/). Once `Docker` is installed, `Popper` can be installed with `curl -sSfL https://raw.githubusercontent.com/getpopper/popper/master/install.sh | sh`.

Since this workflow automatically provisions infrastructure on AWS, credentials need to be provided to create the infrastructure under an AWS account. Platform specific instructions on how to install the aws cli can be found [here](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).

To configure your aws credentials, you can follow the instructions [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html).

Then the following variables in the `wf.yml` file need to be substituted with their specific paths/names on your system:
- `<path to aws credentials file>`
- `<profile name>`
- `<path to .aws directory>`
- `<path to root of this repository>`

Once all of these steps have been completed, the experimental workflow can be automatically executed by running `popper run -f wf.yml` from the root of this directory (where the `wf.yml` file exists)

This will automatically generate ssh keys, provision an aws instance using terraform, install all required dependencies on the instance using ansible, run the experiment on instance using ansible, and visualize the results using jupyter notebooks.




