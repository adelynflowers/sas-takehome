import azure.functions as func
import logging
from aca_rollback import rollback_container_app

app = func.FunctionApp(http_auth_level=func.AuthLevel.FUNCTION)

@app.route(route="http_rollback")
def http_rollback(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')
    resource_group_name = "sastakehome"
    container_app_name = "prod-sastakehome"
    try:
        rollback_container_app(resource_group_name, container_app_name)
        return func.HttpResponse("Rollback successful", status_code=200)
    except Exception as e:
        return func.HttpResponse(f"Rollback failed: {e}", status_code=500)
    # name = req.params.get('name')
    # if not name:
    #     try:
    #         req_body = req.get_json()
    #     except ValueError:
    #         pass
    #     else:
    #         name = req_body.get('name')

    # if name:
    #     return func.HttpResponse(f"Hello, {name}. This HTTP triggered function executed successfully.")
    # else:
    #     return func.HttpResponse(
    #          "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response.",
    #          status_code=200
    #     )