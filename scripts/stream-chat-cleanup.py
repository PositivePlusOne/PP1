import stream_chat

def delete_conversations(api_key, api_secret):
  # Delete all conversations
    client = stream_chat.client.StreamChat(api_key, api_secret)

    # Get all channels
    response = client.query_channels(filter_conditions={})

    # Delete all channels
    for query in response["channels"]:
        print("Deleting channel: ", query["channel"]["id"])
        channel = client.channel(query["channel"]["type"], query["channel"]["id"])
        channel.delete()

    print("All conversations and users deleted")

if __name__ == "__main__":
  api_key = "lol"
  api_secret = "nicetry"
  delete_conversations(api_key, api_secret)
