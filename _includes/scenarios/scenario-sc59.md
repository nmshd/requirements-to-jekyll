<!-- This include inserts the table with the metadata  -->

{% include properties_list.html %}

In order to send messages to recipients, a REST request can be sent with the given `recipients` and message `content`. Different message content structures are possible and defined in the chapter Data Structures. Additionally, an array of file ids can be added for property `attachments` in order to send attachments.

![Send Message Sequence Diagram]({{ '/assets/diagrams/integrate/Connector_SendMessage.png' | relative_url }} "Send Message")
