# NetflixInfra
Repo for CI/CD Ngnix exercises

   Note that in order to automate the deployment process of the app, the workflow should have an SSH private key that authorized to connect to your instance. Since we **NEVER** store secrets in a git repo, you should configure a **Secret** in GitHub Actions and provide it to the workflow as an environment variable, as follows:
   - Go to your project repository on GitHub, navigate to **Settings** > **Secrets and variables** > **Actions**.
   - Click on **New repository secret**.
   - Define a secret named `SSH_PRIVATE_KEY` with the private key value to connect to your EC2.
   - Take a look how this secret is being used in the workflow `service-deploy.yaml` YAML.
