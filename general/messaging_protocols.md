# Messaging Protocols and Message Queues

## Concepts

**Message Queue**: Asynchronous communication between services

```
Producer -> Queue -> Consumer

Benefits:
- Decoupling services
- Load leveling
- Reliability (messages persist)
- Scalability
```

**Patterns:**
- **Point-to-Point**: One producer, one consumer
- **Pub/Sub**: One producer, multiple subscribers
- **Request-Reply**: Producer waits for consumer response

## Message Queue vs Direct API Call

```python
# Direct API call (synchronous)
def process_order(order):
    response = requests.post('http://inventory/reserve', json=order)
    # Waits for response
    # If inventory service is down, order fails

# Message queue (asynchronous)
def process_order(order):
    queue.send('inventory.reserve', order)
    # Returns immediately
    # Message queued even if inventory service is down
```

## RabbitMQ

- AMQP protocol (Advanced Message Queuing Protocol)
- Message broker
- Supports multiple patterns

### Basic Producer/Consumer

```python
# Producer
import pika

connection = pika.BlockingConnection(pika.ConnectionParameters('localhost'))
channel = connection.channel()

# Declare queue
channel.queue_declare(queue='tasks')

# Send message
channel.basic_publish(
    exchange='',
    routing_key='tasks',
    body='Hello RabbitMQ'
)

print("Sent message")
connection.close()
```

```python
# Consumer
import pika

connection = pika.BlockingConnection(pika.ConnectionParameters('localhost'))
channel = connection.channel()

channel.queue_declare(queue='tasks')

def callback(ch, method, properties, body):
    print(f"Received: {body.decode()}")
    # Process message
    ch.basic_ack(delivery_tag=method.delivery_tag)  # Acknowledge

channel.basic_consume(queue='tasks', on_message_callback=callback)

print("Waiting for messages...")
channel.start_consuming()
```

```ruby
# Producer (Ruby)
require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel
queue = channel.queue('tasks')

queue.publish('Hello RabbitMQ')
puts "Sent message"

connection.close
```

### Work Queue (Multiple Workers)

```python
# Multiple consumers share work
# Worker 1
def callback(ch, method, properties, body):
    print(f"Worker 1 processing: {body.decode()}")
    time.sleep(2)  # Simulate work
    ch.basic_ack(delivery_tag=method.delivery_tag)

channel.basic_qos(prefetch_count=1)  # Fair dispatch
channel.basic_consume(queue='tasks', on_message_callback=callback)
channel.start_consuming()

# Worker 2 (same code)
# Messages distributed: Worker 1 gets msg1, Worker 2 gets msg2, etc.
```

### Pub/Sub (Fanout Exchange)

```python
# Publisher
channel.exchange_declare(exchange='logs', exchange_type='fanout')

channel.basic_publish(
    exchange='logs',
    routing_key='',
    body='Log message'
)
# All subscribers receive this message

# Subscriber 1
channel.exchange_declare(exchange='logs', exchange_type='fanout')
result = channel.queue_declare(queue='', exclusive=True)
queue_name = result.method.queue

channel.queue_bind(exchange='logs', queue=queue_name)

def callback(ch, method, properties, body):
    print(f"Subscriber 1 received: {body.decode()}")

channel.basic_consume(queue=queue_name, on_message_callback=callback, auto_ack=True)

# Subscriber 2 (same setup, receives same messages)
```

### Topic Exchange (Routing)

```python
# Publisher with routing key
channel.exchange_declare(exchange='logs', exchange_type='topic')

channel.basic_publish(
    exchange='logs',
    routing_key='error.payment',
    body='Payment error occurred'
)

# Consumer with pattern matching
channel.queue_bind(
    exchange='logs',
    queue=queue_name,
    routing_key='error.*'  # Receives all errors
)

# Patterns:
# * - exactly one word
# # - zero or more words
# error.* - error.payment, error.auth
# *.critical - payment.critical, db.critical
# error.# - error, error.payment, error.payment.stripe
```

## Apache Kafka

- Distributed streaming platform
- High throughput
- Persistent log
- Partitions for scalability

### Concepts

```
Topic: Category of messages (e.g., "orders", "payments")
Partition: Topic split into partitions for parallelism
Producer: Sends messages to topics
Consumer: Reads messages from topics
Consumer Group: Multiple consumers sharing work
Offset: Message position in partition
```

### Python Producer

```python
from kafka import KafkaProducer
import json

producer = KafkaProducer(
    bootstrap_servers=['localhost:9092'],
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

# Send message
producer.send('orders', {'order_id': 123, 'amount': 99.99})
producer.flush()  # Ensure sent

print("Message sent")
producer.close()
```

### Python Consumer

```python
from kafka import KafkaConsumer
import json

consumer = KafkaConsumer(
    'orders',
    bootstrap_servers=['localhost:9092'],
    group_id='order-processors',
    value_deserializer=lambda m: json.loads(m.decode('utf-8'))
)

for message in consumer:
    print(f"Received: {message.value}")
    # Process order
```

```ruby
# Ruby producer
require 'kafka'

kafka = Kafka.new(['localhost:9092'])
producer = kafka.producer

producer.produce('Hello Kafka', topic: 'orders')
producer.deliver_messages

producer.shutdown
```

### Consumer Groups

```python
# Consumer Group: order-processors
# 3 consumers in same group
# Topic: orders (3 partitions)
# Partition 0 -> Consumer 1
# Partition 1 -> Consumer 2
# Partition 2 -> Consumer 3
# Each consumer gets different messages

consumer = KafkaConsumer(
    'orders',
    group_id='order-processors',  # Same group
    bootstrap_servers=['localhost:9092']
)
```

### Multiple Consumer Groups

```python
# Group 1: order-processors (process orders)
consumer1 = KafkaConsumer('orders', group_id='order-processors')

# Group 2: analytics (analyze orders)
consumer2 = KafkaConsumer('orders', group_id='analytics')

# Both groups receive all messages independently
```

## Redis Pub/Sub

- In-memory
- Simple pub/sub
- No message persistence

### Python Publisher

```python
import redis

r = redis.Redis(host='localhost', port=6379)

# Publish message
r.publish('notifications', 'New order received')
print("Message published")
```

### Python Subscriber

```python
import redis

r = redis.Redis(host='localhost', port=6379)
pubsub = r.pubsub()

# Subscribe to channel
pubsub.subscribe('notifications')

for message in pubsub.listen():
    if message['type'] == 'message':
        print(f"Received: {message['data'].decode()}")
```

```ruby
# Ruby subscriber
require 'redis'

redis = Redis.new(host: 'localhost', port: 6379)

redis.subscribe('notifications') do |on|
  on.message do |channel, message|
    puts "Received on #{channel}: #{message}"
  end
end
```

**Note**: Redis Pub/Sub doesn't persist messages. If no subscribers are listening, message is lost.

### Redis Streams (Alternative)

```python
# More reliable than Pub/Sub
import redis

r = redis.Redis()

# Producer
r.xadd('orders', {'order_id': '123', 'amount': '99.99'})

# Consumer
messages = r.xread({'orders': '0'}, block=1000)
for stream, msgs in messages:
    for msg_id, data in msgs:
        print(f"Received: {data}")
```

## AWS SQS (Simple Queue Service)

- Managed message queue
- Scalable
- Reliable

### Python (boto3)

```python
import boto3
import json

sqs = boto3.client('sqs', region_name='us-east-1')
queue_url = 'https://sqs.us-east-1.amazonaws.com/123456789/my-queue'

# Send message
response = sqs.send_message(
    QueueUrl=queue_url,
    MessageBody=json.dumps({'order_id': 123})
)

# Receive message
response = sqs.receive_message(
    QueueUrl=queue_url,
    MaxNumberOfMessages=1,
    WaitTimeSeconds=10  # Long polling
)

if 'Messages' in response:
    for message in response['Messages']:
        print(f"Received: {message['Body']}")

        # Delete message after processing
        sqs.delete_message(
            QueueUrl=queue_url,
            ReceiptHandle=message['ReceiptHandle']
        )
```

## AWS SNS (Simple Notification Service)

- Pub/Sub service
- Push notifications

```python
import boto3

sns = boto3.client('sns', region_name='us-east-1')
topic_arn = 'arn:aws:sns:us-east-1:123456789:my-topic'

# Publish message
response = sns.publish(
    TopicArn=topic_arn,
    Message='New order received',
    Subject='Order Notification'
)

# Subscribe (email, SMS, HTTP endpoint, Lambda, SQS)
response = sns.subscribe(
    TopicArn=topic_arn,
    Protocol='email',
    Endpoint='user@example.com'
)
```

## Google Cloud Pub/Sub

```python
from google.cloud import pubsub_v1
import json

# Publisher
publisher = pubsub_v1.PublisherClient()
topic_path = publisher.topic_path('project-id', 'topic-name')

data = json.dumps({'order_id': 123}).encode('utf-8')
future = publisher.publish(topic_path, data)
print(f"Published message ID: {future.result()}")

# Subscriber
subscriber = pubsub_v1.SubscriberClient()
subscription_path = subscriber.subscription_path('project-id', 'subscription-name')

def callback(message):
    print(f"Received: {message.data.decode()}")
    message.ack()  # Acknowledge

future = subscriber.subscribe(subscription_path, callback)
future.result()  # Block and listen
```

## Message Queue Comparison

```
RabbitMQ:
  ✅ Flexible routing
  ✅ Message acknowledgment
  ✅ Multiple protocols
  ❌ Lower throughput than Kafka
  Use: Complex routing, reliable delivery

Kafka:
  ✅ High throughput
  ✅ Message persistence
  ✅ Replay messages
  ❌ More complex
  Use: Event streaming, logs, analytics

Redis Pub/Sub:
  ✅ Simple
  ✅ Fast
  ❌ No persistence
  ❌ No message guarantee
  Use: Real-time notifications, cache invalidation

SQS:
  ✅ Managed (no ops)
  ✅ Scalable
  ✅ Reliable
  ❌ AWS only
  Use: AWS applications, simple queuing

SNS:
  ✅ Pub/Sub
  ✅ Push to multiple endpoints
  ✅ Mobile push notifications
  ❌ AWS only
  Use: Notifications, fan-out
```

## Message Patterns

### Fire and Forget

```python
# Send message and continue
queue.send('email.send', {'to': 'user@example.com', 'subject': 'Hello'})
# Don't wait for processing
```

### Request-Reply

```python
# Send message and wait for response
import uuid

correlation_id = str(uuid.uuid4())

# Send request
channel.basic_publish(
    exchange='',
    routing_key='rpc_queue',
    properties=pika.BasicProperties(
        reply_to='response_queue',
        correlation_id=correlation_id
    ),
    body='request data'
)

# Wait for response
for message in channel.consume('response_queue'):
    if message.properties.correlation_id == correlation_id:
        print(f"Response: {message.body}")
        break
```

### Competing Consumers

```python
# Multiple consumers process from same queue
# Load distributed across consumers

# Consumer 1, 2, 3 all consume from 'tasks' queue
# Message 1 -> Consumer 1
# Message 2 -> Consumer 2
# Message 3 -> Consumer 3
# Message 4 -> Consumer 1 (round-robin)
```

### Message Priority

```python
# RabbitMQ priority queue
channel.queue_declare(
    queue='tasks',
    arguments={'x-max-priority': 10}
)

# Send high priority message
channel.basic_publish(
    exchange='',
    routing_key='tasks',
    body='urgent task',
    properties=pika.BasicProperties(priority=9)
)

# Send low priority message
channel.basic_publish(
    exchange='',
    routing_key='tasks',
    body='normal task',
    properties=pika.BasicProperties(priority=1)
)
```

### Dead Letter Queue

```python
# Messages that fail processing go to DLQ
channel.queue_declare(
    queue='tasks',
    arguments={
        'x-dead-letter-exchange': 'dlx',
        'x-dead-letter-routing-key': 'failed_tasks'
    }
)

# Consumer
def callback(ch, method, properties, body):
    try:
        # Process message
        process(body)
        ch.basic_ack(delivery_tag=method.delivery_tag)
    except Exception as e:
        # Reject message -> goes to DLQ
        ch.basic_nack(delivery_tag=method.delivery_tag, requeue=False)
```

### Delayed Messages

```python
# RabbitMQ delayed message plugin
channel.exchange_declare(
    exchange='delayed',
    exchange_type='x-delayed-message',
    arguments={'x-delayed-type': 'direct'}
)

# Send message with delay
channel.basic_publish(
    exchange='delayed',
    routing_key='tasks',
    body='delayed task',
    properties=pika.BasicProperties(
        headers={'x-delay': 5000}  # 5 seconds
    )
)
```

## Message Serialization

### JSON

```python
import json

# Serialize
message = json.dumps({'order_id': 123, 'amount': 99.99})

# Deserialize
data = json.loads(message)
```

### Protocol Buffers

```protobuf
// order.proto
message Order {
  int32 order_id = 1;
  double amount = 2;
}
```

```python
# Serialize
order = Order()
order.order_id = 123
order.amount = 99.99
message = order.SerializeToString()

# Deserialize
order = Order()
order.ParseFromString(message)
```

**Benefits**: Smaller size, faster, typed

### MessagePack

```python
import msgpack

# Serialize
message = msgpack.packb({'order_id': 123, 'amount': 99.99})

# Deserialize
data = msgpack.unpackb(message)
```

## Best Practices

```python
# 1. Idempotent consumers
# Handle duplicate messages gracefully
def process_order(order_id):
    if already_processed(order_id):
        return  # Skip
    # Process order

# 2. Message acknowledgment
# Only acknowledge after successful processing
def callback(ch, method, properties, body):
    try:
        process(body)
        ch.basic_ack(delivery_tag=method.delivery_tag)
    except Exception:
        ch.basic_nack(delivery_tag=method.delivery_tag)

# 3. Set message TTL (Time To Live)
# Prevent old messages from clogging queue
channel.basic_publish(
    exchange='',
    routing_key='tasks',
    body='message',
    properties=pika.BasicProperties(expiration='60000')  # 60 seconds
)

# 4. Monitor queue size
# Alert if queue grows too large

# 5. Use dead letter queues
# Catch failed messages for investigation

# 6. Add metadata
# Include timestamp, version, trace ID
message = {
    'data': {'order_id': 123},
    'timestamp': '2024-01-15T10:00:00Z',
    'version': '1.0',
    'trace_id': 'abc123'
}
```

## Error Handling

```python
# Retry with exponential backoff
import time

def process_with_retry(message, max_retries=3):
    for attempt in range(max_retries):
        try:
            process(message)
            return True
        except Exception as e:
            if attempt == max_retries - 1:
                # Send to DLQ
                send_to_dlq(message)
                return False
            wait_time = 2 ** attempt  # 1s, 2s, 4s
            time.sleep(wait_time)
    return False

# Consumer with retry
def callback(ch, method, properties, body):
    success = process_with_retry(body)
    if success:
        ch.basic_ack(delivery_tag=method.delivery_tag)
    else:
        ch.basic_nack(delivery_tag=method.delivery_tag, requeue=False)
```

## Monitoring

```python
# RabbitMQ management API
import requests

response = requests.get('http://localhost:15672/api/queues', auth=('guest', 'guest'))
queues = response.json()

for queue in queues:
    print(f"Queue: {queue['name']}")
    print(f"Messages: {queue['messages']}")
    print(f"Consumers: {queue['consumers']}")
```

## Use Cases

```
Email sending:
  API -> Queue -> Email service
  Benefits: API responds immediately, emails sent async

Image processing:
  Upload -> Queue -> Resize service
  Benefits: Handle spikes, parallel processing

Order processing:
  Order created -> Queue -> Inventory -> Payment -> Shipping
  Benefits: Each service independent

Event sourcing:
  Events -> Kafka -> Multiple consumers (analytics, cache update, notifications)
  Benefits: Replay events, multiple uses

Microservices communication:
  Service A -> Queue -> Service B
  Benefits: Decoupled, reliable
```
