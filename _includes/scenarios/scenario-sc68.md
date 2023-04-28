<!-- This include inserts the table with the metadata  -->

{% include properties_list.html %}


Now you have to send the Request to the Recipient. You can do so by calling the `POST /api/v2/Messages` route on the Sender Connector. Use the following JSON in the Request body:

```jsonc
{
  "recipients": ["<the address of the Recipient Connector>"],
  "content": {
    // the content you copied in the step before
  }
}
```

This is where the automation of the Enmeshed Runtime steps in and moves the Request from status `Draft` to status `Open`. You can observe this behaviour by querying the Request via `GET /api/v2/Requests/Outgoing/{id}` on the Sender Connector.

## Fetch the Request

In order to fetch the Message with the Request, you have to synchronize the Recipient Connector (`GET /api/v2/Account/Sync`).

The Enmeshed Runtime will read the Message and create a new incoming Request. You can observe this by long polling the incoming Requests or by waiting for the `consumption.incomingRequestReceived` event.

The long polling is done by calling the `GET /api/v2/Requests/Incoming` route. You can use the query params `source.reference=<id-of-the-message>` and `status=ManualDecisionRequired` to filter for Requests that belong to the Message that contained the Request.

For more information about the events you can head over to the [Connector Modules site]({% link _docs_integrate/03-connector-modules.md %}) and read about the [AMQP Publisher module]({% link _docs_integrate/03-connector-modules.md %}#amqppublisher) and the [WebhooksV2 module]({% link _docs_integrate/03-connector-modules.md %}#webhooksv2) that are propagating events.

{% include copy-notice description="After you received the Request, save its `id` for the next step." %}
