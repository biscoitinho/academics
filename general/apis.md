# APIs (Application Programming Interfaces)

## REST (Representational State Transfer)

### Key Principles

- **Stateless**: Each request contains all needed information
- **Resource-based**: URLs represent resources
- **HTTP methods**: GET, POST, PUT, DELETE
- **JSON/XML**: Common data formats

### REST Endpoints

```
GET    /users          - List all users
GET    /users/123      - Get user 123
POST   /users          - Create new user
PUT    /users/123      - Update user 123
PATCH  /users/123      - Partial update user 123
DELETE /users/123      - Delete user 123
```

### Python REST API (Flask)

```python
from flask import Flask, jsonify, request

app = Flask(__name__)

users = [
    {'id': 1, 'name': 'Alice'},
    {'id': 2, 'name': 'Bob'}
]

# GET all users
@app.route('/users', methods=['GET'])
def get_users():
    return jsonify(users)

# GET single user
@app.route('/users/<int:user_id>', methods=['GET'])
def get_user(user_id):
    user = next((u for u in users if u['id'] == user_id), None)
    if user:
        return jsonify(user)
    return jsonify({'error': 'Not found'}), 404

# POST create user
@app.route('/users', methods=['POST'])
def create_user():
    data = request.json
    new_user = {
        'id': len(users) + 1,
        'name': data['name']
    }
    users.append(new_user)
    return jsonify(new_user), 201

# PUT update user
@app.route('/users/<int:user_id>', methods=['PUT'])
def update_user(user_id):
    user = next((u for u in users if u['id'] == user_id), None)
    if user:
        data = request.json
        user['name'] = data['name']
        return jsonify(user)
    return jsonify({'error': 'Not found'}), 404

# DELETE user
@app.route('/users/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    global users
    users = [u for u in users if u['id'] != user_id]
    return '', 204

if __name__ == '__main__':
    app.run(port=5000)
```

### Ruby REST API (Sinatra)

```ruby
require 'sinatra'
require 'json'

users = [
  { id: 1, name: 'Alice' },
  { id: 2, name: 'Bob' }
]

# GET all users
get '/users' do
  content_type :json
  users.to_json
end

# GET single user
get '/users/:id' do
  user = users.find { |u| u[:id] == params[:id].to_i }
  if user
    content_type :json
    user.to_json
  else
    status 404
    { error: 'Not found' }.to_json
  end
end

# POST create user
post '/users' do
  data = JSON.parse(request.body.read, symbolize_names: true)
  new_user = {
    id: users.length + 1,
    name: data[:name]
  }
  users << new_user
  status 201
  content_type :json
  new_user.to_json
end
```

### REST Client

```python
import requests

# GET
response = requests.get('http://localhost:5000/users')
print(response.json())  # [{'id': 1, 'name': 'Alice'}, ...]

# POST
new_user = {'name': 'Charlie'}
response = requests.post('http://localhost:5000/users', json=new_user)
print(response.status_code)  # 201

# PUT
updated = {'name': 'Alice Updated'}
response = requests.put('http://localhost:5000/users/1', json=updated)

# DELETE
response = requests.delete('http://localhost:5000/users/1')
print(response.status_code)  # 204
```

```ruby
require 'net/http'
require 'json'

uri = URI('http://localhost:4567/users')

# GET
response = Net::HTTP.get(uri)
users = JSON.parse(response)

# POST
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
request.body = { name: 'Charlie' }.to_json
response = http.request(request)
```

### REST Best Practices

```
1. Use nouns for resources, not verbs
   ✅ GET /users/123
   ❌ GET /getUser?id=123

2. Use HTTP methods correctly
   GET    - Read only
   POST   - Create
   PUT    - Full update
   PATCH  - Partial update
   DELETE - Remove

3. Return appropriate status codes
   200 - OK
   201 - Created
   204 - No Content
   400 - Bad Request
   404 - Not Found
   500 - Server Error

4. Version your API
   /v1/users
   /v2/users

5. Use pagination for lists
   GET /users?page=2&limit=20
```

## SOAP (Simple Object Access Protocol)

- XML-based protocol
- Strictly defined structure
- WSDL (Web Services Description Language)
- More complex than REST

```xml
<!-- SOAP Request -->
<?xml version="1.0"?>
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
  <soap:Header>
  </soap:Header>
  <soap:Body>
    <m:GetUser xmlns:m="https://example.com">
      <m:UserId>123</m:UserId>
    </m:GetUser>
  </soap:Body>
</soap:Envelope>

<!-- SOAP Response -->
<?xml version="1.0"?>
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
  <soap:Body>
    <m:GetUserResponse xmlns:m="https://example.com">
      <m:User>
        <m:Id>123</m:Id>
        <m:Name>Alice</m:Name>
      </m:User>
    </m:GetUserResponse>
  </soap:Body>
</soap:Envelope>
```

```python
# Python SOAP client (using zeep)
from zeep import Client

client = Client('https://example.com/service?wsdl')
result = client.service.GetUser(UserId=123)
print(result)
```

**Use cases:**
- Enterprise applications
- Banking/financial systems
- Legacy systems

## GraphQL

- Query language for APIs
- Request exactly what you need
- Single endpoint
- Strongly typed

### GraphQL Schema

```graphql
type User {
  id: ID!
  name: String!
  email: String
  posts: [Post]
}

type Post {
  id: ID!
  title: String!
  content: String!
  author: User!
}

type Query {
  user(id: ID!): User
  users: [User]
  post(id: ID!): Post
}

type Mutation {
  createUser(name: String!, email: String): User
  updateUser(id: ID!, name: String): User
  deleteUser(id: ID!): Boolean
}
```

### GraphQL Queries

```graphql
# Get specific fields
query {
  user(id: 1) {
    name
    email
  }
}

# Get nested data
query {
  user(id: 1) {
    name
    posts {
      title
      content
    }
  }
}

# Multiple queries
query {
  user1: user(id: 1) {
    name
  }
  user2: user(id: 2) {
    name
  }
}

# Mutation
mutation {
  createUser(name: "Charlie", email: "charlie@example.com") {
    id
    name
  }
}
```

### Python GraphQL Server (Graphene)

```python
import graphene

class User(graphene.ObjectType):
    id = graphene.Int()
    name = graphene.String()
    email = graphene.String()

class Query(graphene.ObjectType):
    user = graphene.Field(User, id=graphene.Int())
    users = graphene.List(User)

    def resolve_user(self, info, id):
        # Fetch from database
        return User(id=id, name="Alice", email="alice@example.com")

    def resolve_users(self, info):
        # Fetch all from database
        return [
            User(id=1, name="Alice", email="alice@example.com"),
            User(id=2, name="Bob", email="bob@example.com")
        ]

class CreateUser(graphene.Mutation):
    class Arguments:
        name = graphene.String()
        email = graphene.String()

    user = graphene.Field(User)

    def mutate(self, info, name, email):
        user = User(id=3, name=name, email=email)
        # Save to database
        return CreateUser(user=user)

class Mutation(graphene.ObjectType):
    create_user = CreateUser.Field()

schema = graphene.Schema(query=Query, mutation=Mutation)
```

### GraphQL Client

```python
import requests

query = """
{
  user(id: 1) {
    name
    email
  }
}
"""

response = requests.post('http://localhost:5000/graphql',
    json={'query': query})
print(response.json())
```

```ruby
# Ruby GraphQL client
require 'net/http'
require 'json'

uri = URI('http://localhost:4000/graphql')

query = <<~GRAPHQL
  {
    user(id: 1) {
      name
      email
    }
  }
GRAPHQL

http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
request.body = { query: query }.to_json
response = http.request(request)
```

**Advantages:**
- No over-fetching or under-fetching
- Single request for multiple resources
- Strong typing
- Self-documenting

**Disadvantages:**
- More complex than REST
- Caching is harder
- Learning curve

## gRPC

- Google's RPC framework
- Uses Protocol Buffers (protobuf)
- Binary format (fast)
- HTTP/2

### Protocol Buffer Definition

```protobuf
// user.proto
syntax = "proto3";

message User {
  int32 id = 1;
  string name = 2;
  string email = 3;
}

message GetUserRequest {
  int32 id = 1;
}

message GetUserResponse {
  User user = 1;
}

service UserService {
  rpc GetUser(GetUserRequest) returns (GetUserResponse);
  rpc ListUsers(Empty) returns (stream User);
}
```

### Python gRPC Server

```python
import grpc
from concurrent import futures
import user_pb2
import user_pb2_grpc

class UserService(user_pb2_grpc.UserServiceServicer):
    def GetUser(self, request, context):
        user = user_pb2.User(
            id=request.id,
            name="Alice",
            email="alice@example.com"
        )
        return user_pb2.GetUserResponse(user=user)

server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
user_pb2_grpc.add_UserServiceServicer_to_server(UserService(), server)
server.add_insecure_port('[::]:50051')
server.start()
server.wait_for_termination()
```

### Python gRPC Client

```python
import grpc
import user_pb2
import user_pb2_grpc

channel = grpc.insecure_channel('localhost:50051')
stub = user_pb2_grpc.UserServiceStub(channel)

request = user_pb2.GetUserRequest(id=1)
response = stub.GetUser(request)
print(response.user.name)  # Alice
```

**Advantages:**
- Fast (binary format)
- Streaming support
- Multi-language
- Strong typing

**Use cases:**
- Microservices communication
- Mobile applications
- Real-time systems

## WebSocket API

- Bidirectional communication
- Persistent connection
- Real-time updates

```python
# Python WebSocket server
import asyncio
import websockets
import json

connections = set()

async def handler(websocket):
    connections.add(websocket)
    try:
        async for message in websocket:
            data = json.loads(message)
            # Broadcast to all connections
            for conn in connections:
                await conn.send(json.dumps({
                    'type': 'message',
                    'data': data
                }))
    finally:
        connections.remove(websocket)

async def main():
    async with websockets.serve(handler, "localhost", 8765):
        await asyncio.Future()

asyncio.run(main())
```

```python
# Python WebSocket client
import asyncio
import websockets
import json

async def client():
    async with websockets.connect("ws://localhost:8765") as websocket:
        # Send message
        await websocket.send(json.dumps({'text': 'Hello'}))

        # Receive messages
        async for message in websocket:
            data = json.loads(message)
            print(data)

asyncio.run(client())
```

**Use cases:**
- Chat applications
- Live notifications
- Collaborative editing
- Gaming

## API Comparison

```
REST:
  ✅ Simple
  ✅ Cacheable
  ✅ Widely supported
  ❌ Over-fetching
  ❌ Multiple requests

GraphQL:
  ✅ Flexible queries
  ✅ Single endpoint
  ✅ No over-fetching
  ❌ Complex
  ❌ Caching harder

gRPC:
  ✅ Fast (binary)
  ✅ Streaming
  ✅ Strong typing
  ❌ Not browser-friendly
  ❌ Less readable

SOAP:
  ✅ Strict standards
  ✅ Security features
  ❌ Complex
  ❌ XML overhead
  ❌ Outdated

WebSocket:
  ✅ Real-time
  ✅ Bidirectional
  ✅ Low latency
  ❌ More complex
  ❌ Scalability challenges
```

## API Authentication

### API Keys

```python
# Send API key in header
headers = {'X-API-Key': 'your-api-key-here'}
response = requests.get('https://api.example.com/users', headers=headers)

# Or in query parameter
response = requests.get('https://api.example.com/users?api_key=your-key')
```

### Bearer Token (JWT)

```python
# JWT token in Authorization header
headers = {'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'}
response = requests.get('https://api.example.com/users', headers=headers)
```

### OAuth 2.0

```python
# OAuth flow
# 1. Get authorization code
# 2. Exchange for access token
# 3. Use access token

import requests

# Step 2: Exchange authorization code for token
token_url = 'https://oauth.example.com/token'
data = {
    'grant_type': 'authorization_code',
    'code': 'authorization-code',
    'client_id': 'your-client-id',
    'client_secret': 'your-client-secret',
    'redirect_uri': 'http://localhost/callback'
}
response = requests.post(token_url, data=data)
access_token = response.json()['access_token']

# Step 3: Use access token
headers = {'Authorization': f'Bearer {access_token}'}
response = requests.get('https://api.example.com/users', headers=headers)
```

## Rate Limiting

```python
# Server-side rate limiting (Flask)
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address

limiter = Limiter(
    app,
    key_func=get_remote_address,
    default_limits=["100 per hour"]
)

@app.route('/users')
@limiter.limit("10 per minute")
def get_users():
    return jsonify(users)
```

```python
# Client-side: Handle rate limits
import time

response = requests.get('https://api.example.com/users')

if response.status_code == 429:  # Too Many Requests
    retry_after = int(response.headers.get('Retry-After', 60))
    print(f"Rate limited. Waiting {retry_after} seconds")
    time.sleep(retry_after)
    response = requests.get('https://api.example.com/users')
```

## API Versioning

```
1. URL path
   /v1/users
   /v2/users

2. Query parameter
   /users?version=1

3. Header
   X-API-Version: 1

4. Content negotiation
   Accept: application/vnd.example.v1+json
```

## Error Handling

```python
# REST API error response
{
    "error": {
        "code": "USER_NOT_FOUND",
        "message": "User with id 123 not found",
        "status": 404
    }
}

# Client error handling
try:
    response = requests.get('https://api.example.com/users/123')
    response.raise_for_status()  # Raises exception for 4xx/5xx
    data = response.json()
except requests.HTTPError as e:
    if e.response.status_code == 404:
        print("User not found")
    elif e.response.status_code == 500:
        print("Server error")
except requests.ConnectionError:
    print("Connection failed")
except requests.Timeout:
    print("Request timed out")
```

## API Documentation

```
OpenAPI (Swagger):
- REST API documentation standard
- Interactive documentation
- Code generation

Example:
swagger: "2.0"
info:
  title: "User API"
  version: "1.0"
paths:
  /users:
    get:
      summary: "Get all users"
      responses:
        200:
          description: "Success"
          schema:
            type: array
            items:
              $ref: "#/definitions/User"
definitions:
  User:
    type: object
    properties:
      id:
        type: integer
      name:
        type: string
```

## Webhooks

```python
# Webhook receiver (server)
@app.route('/webhook', methods=['POST'])
def webhook():
    data = request.json
    print(f"Received webhook: {data}")
    # Process event
    return '', 200

# Webhook sender (notify URL when event occurs)
import requests

def send_webhook(url, event):
    requests.post(url, json={
        'event': event,
        'timestamp': '2024-01-15T10:00:00Z',
        'data': {'user_id': 123}
    })

# When user is created:
send_webhook('https://client.com/webhook', 'user.created')
```

**Use cases:**
- Payment notifications (Stripe)
- CI/CD triggers (GitHub)
- Chat bots (Slack)
