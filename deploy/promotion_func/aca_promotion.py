from azure.identity import DefaultAzureCredential
from azure.mgmt.appcontainers import ContainerAppsAPIClient
from azure.mgmt.appcontainers.operations import ContainerAppsRevisionsOperations, ContainerAppsOperations
from azure.mgmt.appcontainers.models import Revision, TrafficWeight, ContainerApp
from loguru import logger
import os

def promote_container_app(resource_group_name, container_app_name):
    logger.info(f"Promoting container app {container_app_name} in resource group {resource_group_name}")
    logger.info("Authenticating...")
    # Authenticate using default credentials
    credential = DefaultAzureCredential()
    logger.info("Authenticated!")
    # Get desired revisions

    sub_id = "7e63d45c-9aa0-4a0c-a212-281bb2691e5b"
    logger.info("Getting revisions...")
    client: ContainerAppsAPIClient = ContainerAppsAPIClient(credential=DefaultAzureCredential(), subscription_id=sub_id)
    revisions_client: ContainerAppsRevisionsOperations  = client.container_apps_revisions
    revisions_lst: list[Revision] = [revision for revision in revisions_client.list_revisions(resource_group_name, container_app_name)]
    logger.info(f"Got revisions: {[revision.name for revision in revisions_lst]}")
    logger.debug(f"Revisions: {revisions_lst}")
    revisions_lst.sort(key=lambda revision: revision.created_time, reverse=True)
    green_revision: Revision = revisions_lst[0]
    blue_revision: Revision = revisions_lst[1]
    logger.info(f"Green revision: {green_revision.name}")
    logger.info(f"Blue revision: {blue_revision.name}")
    
    # Create traffic weights and swap labels
    logger.info("Creating traffic weights...")
    current_traffic = TrafficWeight(revision_name=blue_revision.name, weight=0, label=None)
    target_traffic = TrafficWeight(revision_name=green_revision.name, weight=100, label="blue")

    # Create container app
    logger.info("Getting container app...")
    ca_ops: ContainerAppsOperations = client.container_apps
    container_app: ContainerApp = ca_ops.get(resource_group_name, container_app_name)
    logger.info(f"Got container app: {container_app.name}")
    container_app.configuration.ingress.traffic = [current_traffic, target_traffic]

    logger.info("Updating container app...")
    result = ca_ops.begin_update(resource_group_name, container_app_name, container_app)
    logger.info("Waiting for container app update to finish...")
    logger.info(result.result())
    logger.info("Container app update finished")

    # Deactivate old revision
    logger.info(f"Deactivating revision {blue_revision.name}")
    revisions_client.deactivate_revision(resource_group_name, container_app_name, blue_revision.name)
    logger.info(f"Deactivated revision {blue_revision.name}")
   



if __name__ == "__main__":
    # Replace with your actual resource group and container group names
    resource_group_name = "sastakehome"
    container_app_name = "prod-sastakehome"

    rollback_container_app(resource_group_name, container_app_name)
