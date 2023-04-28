<!-- This include inserts the table with the metadata  -->

{% include properties_list.html %}


In order to fetch the Message with the Request, you have to synchronize the Recipient Connector (`GET /api/v2/Account/Sync`).

The Enmeshed Runtime will read the Message and create a new incoming Request. You can observe this by long polling the incoming Requests or by waiting for the `consumption.incomingRequestReceived` event.

The long polling is done by calling the `GET /api/v2/Requests/Incoming` route. You can use the query params `source.reference=<id-of-the-message>` and `status=ManualDecisionRequired` to filter for Requests that belong to the Message that contained the Request.

For more information about the events you can head over to the [Connector Modules site]({% link _docs_integrate/03-connector-modules.md %}) and read about the [AMQP Publisher module]({% link _docs_integrate/03-connector-modules.md %}#amqppublisher) and the [WebhooksV2 module]({% link _docs_integrate/03-connector-modules.md %}#webhooksv2) that are propagating events.

{% include copy-notice description="After you received the Request, save its `id` for the next step." %}