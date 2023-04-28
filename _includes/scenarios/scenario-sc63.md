<!-- This include inserts the table with the metadata  -->

{% include properties_list.html %}

At first you should check if your Request is valid. You can do this by calling the `POST /api/v2/Requests/Outgoing/Validate` route on the Templator Connector with the following body.
For simplicity the Request inside the Template only contains an AuthenticationRequestItem, but you can use any [RequestItems]({% link _docs_integrate/62-request-items.md %}) you want.

Even though the `peer` property is optional, it is recommended to specify it whenever possible. This allows additional validation rules to execute. When you are sending a Request over Messages you always know your peer.

```json
{
  "content": {
    "items": [
      {
        "@type": "AuthenticationRequestItem",
        "mustBeAccepted": true,
        "title": "The Sender is asking for an authentication"
      }
    ]
  },
  "peer": "<the address of the Recipient Connector>"
}
```
```

Even though the Requests are validated during the RelationshipTemplate creation you should not skip this step as it gives you additional information in case of validation errors.
{: .notice--info}
