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

## Notes
In order to provision infrastructure, one must already have aws credentials; These credentials can be shared with a docker container that has aws using `docker run -v ~/.aws:/root/.aws`.
Additionally, one must generate their own ssh key(s) for the node(s) since ansible needs ssh to configure nodes. This step could be done automatically with terraform but then the private key will be saved in the state file and opens up security risks.

