# SAS Take-home Assignment
![Design Diagram](sastakehome.jpg)

This repo is my attempt at gaining practical knowledge about implementing a CI/CD pipeline using Azure and Github Actions. 
Although incomplete compared to my design diagram, I was able to implement ~70% of what was described.

## Features
Here's what this repo does have:

- Automated PR workflows for building and testing changes
- A 3-environment workflow utilizing Terraform for ephemeral environment creation
- Basic samples of unit tests, integration tests, and e2e tests
- Two-layer gated approval for prod deployment
- Blue/Green deployments using Container App Revisions
- Automated alert provisioning with rollback

## WIP
The things missing from the implementation are:
- **Gated 24hr promotion for blue/green deployments**: While the promotion function exists, scheduling an Azure function
appears to be more involved than anticipated. Ran out of time.
- **Linting, static analysis, secrets detection**: This was a low priority for me, and got cut due to time.

