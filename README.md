# NetflixInfra
Repo for CI/CD Ngnix exercises

   Note that in order to automate the deployment process of the app, the workflow should have an SSH private key that authorized to connect to your instance. Since we **NEVER** store secrets in a git repo, you should configure a **Secret** in GitHub Actions and provide it to the workflow as an environment variable, as follows:
   - Go to your project repository on GitHub, navigate to **Settings** > **Secrets and variables** > **Actions**.
   - Click on **New repository secret**.
   - Define a secret named `SSH_PRIVATE_KEY` with the private key value to connect to your EC2.
   - Take a look how this secret is being used in the workflow `service-deploy.yaml` YAML.






### :pencil2: CI/CD for the Nginx configuration files

In this exercise, you will set up a CI/CD pipeline to automate the deployment of Nginx configuration files to your EC2 instance.
The goal is to automatically update and reload Nginx whenever you make changes to its configuration files and push them to your repository.

- Create a new GitHub repo named **NetflixInfra** and clone it locally. 
  In your repository, create a folder named `nginx-config` and place your Nginx configuration files (`default.conf`, etc.) inside it.

- Create a new workflow file under `.github/workflows/nginx-deploy.yaml` in your repository. 
  
  In the `nginx-deploy.yaml` file, write a GitHub Actions workflow that:
     - Uses the SSH private key to connect to your EC2 instance.
     - Transfers the updated Nginx configuration files from the `nginx-config` folder to the appropriate directory on your EC2 instance.
     - Restarts the Nginx service on your EC2 instance to apply the changes.

- Test the CI/CD Pipeline by making a small change to your Nginx configuration files, commit and push the changes to your repository.
  Observe the GitHub Actions workflow being triggered and completing the deployment process.
