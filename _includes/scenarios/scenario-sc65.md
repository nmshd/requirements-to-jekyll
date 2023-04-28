<!-- This include inserts the table with the metadata  -->

{% include properties_list.html %}

Now you have to load the Template on the Requestor Connector. You can do so by calling the `POST /api/v2/RelationshipTemplates/Peer` route with the following content. Use the `truncatedReference` you copied before:

```jsonc
{
  "reference": "UkxU..."
}
```

If no Relationship exists, this will trigger a process in the Enmeshed Runtime. It will create a new incoming Request on which we will work in the next step. You can observe this by long polling the incoming Requests or by waiting for the `consumption.incomingRequestReceived` event.

The long polling is done by calling the `GET /api/v2/Requests/Incoming` route. You can use the query params `source.reference=<id-of-the-template>` and `status=ManualDecisionRequired` to filter for Requests that belong to the Template you are currently working on.

For more information about the events you can head over to the [Connector Modules site]({% link _docs_integrate/03-connector-modules.md %}) and read about the [AMQP Publisher module]({% link _docs_integrate/03-connector-modules.md %}#amqppublisher) and the [WebhooksV2 module]({% link _docs_integrate/03-connector-modules.md %}#webhooksv2) that are propagating events.

{% include copy-notice description="After you received the Request, save its `id` for the next step." %}