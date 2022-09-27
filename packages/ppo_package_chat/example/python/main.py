# pip install stream-chat
import stream_chat


server_client = stream_chat.StreamChat(api_key="32r2zndjnpux", api_secret="a8ba3mm6k7zb6uvesexna6e9rbr6x6jfefnd8cb5zz6cvuwb3nwp52r78vmch8kh")
token = server_client.create_token('Rion-Dixoff')
print(token)
