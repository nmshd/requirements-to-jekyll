<!-- This include inserts the table with the metadata  -->

{% include properties_list.html %}

The Sender will receive the Response as a Message. Therefore you have to synchronize the Sender Connector (`GET /api/v2/Account/Sync`).

After a few seconds the Request has moved to status `Completed` and the Response is available in the `response` property of the Request. You can observe this by querying the Request via `GET /api/v2/Requests/Outgoing/{id}` on the Sender Connector.
