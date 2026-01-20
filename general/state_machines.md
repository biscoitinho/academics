# State Machines

## What is a State Machine?

A system that can be in one of a finite number of states. It transitions between states based on events/inputs.

```
States: Defined conditions
Transitions: Move from one state to another
Events: Triggers that cause transitions
Actions: Operations performed during transitions
```

## Simple Example: Traffic Light

```
States: Red, Yellow, Green
Transitions:
  Red -> Green (timer expires)
  Green -> Yellow (timer expires)
  Yellow -> Red (timer expires)
```

```python
class TrafficLight:
    def __init__(self):
        self.state = 'RED'

    def next(self):
        if self.state == 'RED':
            self.state = 'GREEN'
        elif self.state == 'GREEN':
            self.state = 'YELLOW'
        elif self.state == 'YELLOW':
            self.state = 'RED'

    def get_state(self):
        return self.state

# Usage
light = TrafficLight()
print(light.get_state())  # RED
light.next()
print(light.get_state())  # GREEN
light.next()
print(light.get_state())  # YELLOW
```

```ruby
class TrafficLight
  def initialize
    @state = :red
  end

  def next
    @state = case @state
    when :red then :green
    when :green then :yellow
    when :yellow then :red
    end
  end

  def state
    @state
  end
end

# Usage
light = TrafficLight.new
puts light.state  # red
light.next
puts light.state  # green
```

## Door State Machine

```
States: Closed, Open, Locked
Events: open, close, lock, unlock

Transitions:
  Closed + open -> Open
  Open + close -> Closed
  Closed + lock -> Locked
  Locked + unlock -> Closed
```

```python
class Door:
    def __init__(self):
        self.state = 'CLOSED'

    def open(self):
        if self.state == 'CLOSED':
            self.state = 'OPEN'
            print("Door opened")
        else:
            print(f"Cannot open from {self.state}")

    def close(self):
        if self.state == 'OPEN':
            self.state = 'CLOSED'
            print("Door closed")
        else:
            print(f"Cannot close from {self.state}")

    def lock(self):
        if self.state == 'CLOSED':
            self.state = 'LOCKED'
            print("Door locked")
        else:
            print(f"Cannot lock from {self.state}")

    def unlock(self):
        if self.state == 'LOCKED':
            self.state = 'CLOSED'
            print("Door unlocked")
        else:
            print(f"Cannot unlock from {self.state}")

# Usage
door = Door()
door.open()    # Door opened
door.close()   # Door closed
door.lock()    # Door locked
door.open()    # Cannot open from LOCKED
door.unlock()  # Door unlocked
door.open()    # Door opened
```

## Order State Machine

```
States: Pending, Paid, Shipped, Delivered, Cancelled

Transitions:
  Pending -> Paid (payment received)
  Pending -> Cancelled (timeout or user cancels)
  Paid -> Shipped (item dispatched)
  Shipped -> Delivered (received by customer)
  Paid -> Cancelled (refund issued)
```

```python
class Order:
    VALID_TRANSITIONS = {
        'PENDING': ['PAID', 'CANCELLED'],
        'PAID': ['SHIPPED', 'CANCELLED'],
        'SHIPPED': ['DELIVERED'],
        'DELIVERED': [],
        'CANCELLED': []
    }

    def __init__(self, order_id):
        self.order_id = order_id
        self.state = 'PENDING'

    def transition_to(self, new_state):
        if new_state in self.VALID_TRANSITIONS[self.state]:
            print(f"Order {self.order_id}: {self.state} -> {new_state}")
            self.state = new_state
            return True
        else:
            print(f"Invalid transition: {self.state} -> {new_state}")
            return False

    def pay(self):
        return self.transition_to('PAID')

    def ship(self):
        return self.transition_to('SHIPPED')

    def deliver(self):
        return self.transition_to('DELIVERED')

    def cancel(self):
        return self.transition_to('CANCELLED')

# Usage
order = Order(123)
order.pay()      # Order 123: PENDING -> PAID
order.ship()     # Order 123: PAID -> SHIPPED
order.deliver()  # Order 123: SHIPPED -> DELIVERED
order.cancel()   # Invalid transition: DELIVERED -> CANCELLED
```

```ruby
class Order
  VALID_TRANSITIONS = {
    pending: [:paid, :cancelled],
    paid: [:shipped, :cancelled],
    shipped: [:delivered],
    delivered: [],
    cancelled: []
  }

  attr_reader :state

  def initialize(order_id)
    @order_id = order_id
    @state = :pending
  end

  def transition_to(new_state)
    if VALID_TRANSITIONS[@state].include?(new_state)
      puts "Order #{@order_id}: #{@state} -> #{new_state}"
      @state = new_state
      true
    else
      puts "Invalid transition: #{@state} -> #{new_state}"
      false
    end
  end

  def pay
    transition_to(:paid)
  end

  def ship
    transition_to(:shipped)
  end
end
```

## State Machine with Actions

```python
class Turnstile:
    def __init__(self):
        self.state = 'LOCKED'
        self.coins = 0

    def insert_coin(self):
        if self.state == 'LOCKED':
            self.coins += 1
            self.state = 'UNLOCKED'
            print(f"Unlocked. Coins: {self.coins}")
        elif self.state == 'UNLOCKED':
            self.coins += 1
            print(f"Already unlocked. Coins: {self.coins}")

    def push(self):
        if self.state == 'UNLOCKED':
            self.state = 'LOCKED'
            print("Passed through. Locked again.")
        elif self.state == 'LOCKED':
            print("Locked. Insert coin first.")

# Usage
turnstile = Turnstile()
turnstile.push()          # Locked. Insert coin first.
turnstile.insert_coin()   # Unlocked. Coins: 1
turnstile.push()          # Passed through. Locked again.
```

## FSM with Entry/Exit Actions

```python
class Connection:
    def __init__(self):
        self.state = 'DISCONNECTED'

    def _enter_state(self, state):
        print(f"Entering {state}")
        if state == 'CONNECTED':
            self._setup_connection()
        elif state == 'DISCONNECTED':
            self._cleanup()

    def _exit_state(self, state):
        print(f"Exiting {state}")

    def _setup_connection(self):
        print("Setting up connection...")

    def _cleanup(self):
        print("Cleaning up...")

    def connect(self):
        if self.state == 'DISCONNECTED':
            self._exit_state(self.state)
            self.state = 'CONNECTING'
            self._enter_state(self.state)
            # Simulate connection...
            self._exit_state(self.state)
            self.state = 'CONNECTED'
            self._enter_state(self.state)

    def disconnect(self):
        if self.state == 'CONNECTED':
            self._exit_state(self.state)
            self.state = 'DISCONNECTED'
            self._enter_state(self.state)

# Usage
conn = Connection()
conn.connect()     # Exiting DISCONNECTED -> Entering CONNECTING ->
                  # Exiting CONNECTING -> Entering CONNECTED -> Setting up...
conn.disconnect()  # Exiting CONNECTED -> Entering DISCONNECTED -> Cleaning up...
```

## State Pattern (Design Pattern)

```python
# Each state is a class
class State:
    def handle(self, context):
        raise NotImplementedError

class ClosedState(State):
    def open(self, context):
        print("Opening door")
        context.state = OpenState()

    def lock(self, context):
        print("Locking door")
        context.state = LockedState()

class OpenState(State):
    def close(self, context):
        print("Closing door")
        context.state = ClosedState()

class LockedState(State):
    def unlock(self, context):
        print("Unlocking door")
        context.state = ClosedState()

class Door:
    def __init__(self):
        self.state = ClosedState()

    def open(self):
        if hasattr(self.state, 'open'):
            self.state.open(self)
        else:
            print("Cannot open")

    def close(self):
        if hasattr(self.state, 'close'):
            self.state.close(self)
        else:
            print("Cannot close")

    def lock(self):
        if hasattr(self.state, 'lock'):
            self.state.lock(self)
        else:
            print("Cannot lock")

    def unlock(self):
        if hasattr(self.state, 'unlock'):
            self.state.unlock(self)
        else:
            print("Cannot unlock")

# Usage
door = Door()
door.open()   # Opening door
door.close()  # Closing door
door.lock()   # Locking door
door.open()   # Cannot open
```

## Hierarchical State Machine

```python
# States can have substates
class Media:
    def __init__(self):
        self.state = 'STOPPED'

    def play(self):
        if self.state == 'STOPPED':
            self.state = 'PLAYING'
            print("Playing")
        elif self.state == 'PAUSED':
            self.state = 'PLAYING'
            print("Resuming")

    def pause(self):
        if self.state == 'PLAYING':
            self.state = 'PAUSED'
            print("Paused")

    def stop(self):
        if self.state in ['PLAYING', 'PAUSED']:
            self.state = 'STOPPED'
            print("Stopped")

# States:
# - Stopped
# - Playing
#   - Normal speed
#   - Fast forward
#   - Rewind
# - Paused
```

## State Machine Libraries

### Python: transitions

```python
from transitions import Machine

class Matter:
    states = ['solid', 'liquid', 'gas', 'plasma']

    def __init__(self):
        self.machine = Machine(
            model=self,
            states=Matter.states,
            initial='solid'
        )

        # Add transitions
        self.machine.add_transition('melt', 'solid', 'liquid')
        self.machine.add_transition('evaporate', 'liquid', 'gas')
        self.machine.add_transition('sublimate', 'solid', 'gas')
        self.machine.add_transition('ionize', 'gas', 'plasma')

# Usage
matter = Matter()
print(matter.state)  # solid
matter.melt()
print(matter.state)  # liquid
matter.evaporate()
print(matter.state)  # gas
```

### Ruby: state_machines

```ruby
require 'state_machines'

class Order
  attr_accessor :state

  state_machine :state, initial: :pending do
    event :pay do
      transition pending: :paid
    end

    event :ship do
      transition paid: :shipped
    end

    event :deliver do
      transition shipped: :delivered
    end

    event :cancel do
      transition [:pending, :paid] => :cancelled
    end
  end
end

# Usage
order = Order.new
order.state        # :pending
order.pay
order.state        # :paid
order.ship
order.state        # :shipped
```

## Guard Conditions

```python
class Account:
    def __init__(self, balance=0):
        self.balance = balance
        self.state = 'ACTIVE'

    def withdraw(self, amount):
        if self.state == 'ACTIVE':
            if self.balance >= amount:  # Guard condition
                self.balance -= amount
                print(f"Withdrew {amount}. Balance: {self.balance}")
                if self.balance == 0:
                    self.state = 'EMPTY'
            else:
                print("Insufficient funds")
                self.state = 'OVERDRAWN'
        elif self.state == 'FROZEN':
            print("Account is frozen")

    def deposit(self, amount):
        if self.state in ['ACTIVE', 'EMPTY', 'OVERDRAWN']:
            self.balance += amount
            self.state = 'ACTIVE'
            print(f"Deposited {amount}. Balance: {self.balance}")

    def freeze(self):
        self.state = 'FROZEN'

# Usage
account = Account(100)
account.withdraw(50)  # Withdrew 50. Balance: 50
account.withdraw(60)  # Insufficient funds (state: OVERDRAWN)
account.deposit(100)  # Deposited 100. Balance: 150 (state: ACTIVE)
```

## State Machine in Database

```sql
-- Orders table
CREATE TABLE orders (
    id INT PRIMARY KEY,
    status VARCHAR(20),
    CHECK (status IN ('pending', 'paid', 'shipped', 'delivered', 'cancelled'))
);

-- State transition log
CREATE TABLE order_state_changes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    from_state VARCHAR(20),
    to_state VARCHAR(20),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trigger to log state changes
DELIMITER //
CREATE TRIGGER log_state_change
BEFORE UPDATE ON orders
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO order_state_changes (order_id, from_state, to_state)
        VALUES (NEW.id, OLD.status, NEW.status);
    END IF;
END//
DELIMITER ;
```

```python
# Application code
def transition_order(order_id, new_status):
    # Check if transition is valid
    current_status = db.get_order_status(order_id)

    valid_transitions = {
        'pending': ['paid', 'cancelled'],
        'paid': ['shipped', 'cancelled'],
        'shipped': ['delivered'],
    }

    if new_status in valid_transitions.get(current_status, []):
        db.update_order_status(order_id, new_status)
        return True
    else:
        raise ValueError(f"Invalid transition: {current_status} -> {new_status}")
```

## Common Use Cases

```
1. Order processing
   - Pending -> Paid -> Shipped -> Delivered

2. User authentication
   - Anonymous -> Authenticated -> Verified

3. Document workflow
   - Draft -> Review -> Approved -> Published

4. Connection states
   - Disconnected -> Connecting -> Connected -> Disconnecting

5. Game states
   - Menu -> Loading -> Playing -> Paused -> GameOver

6. Payment processing
   - Initiated -> Processing -> Completed/Failed

7. Task workflow
   - Todo -> In Progress -> Review -> Done
```

## Best Practices

```python
# 1. Explicit state validation
def transition_to(self, new_state):
    if new_state not in self.VALID_TRANSITIONS[self.state]:
        raise ValueError(f"Invalid transition: {self.state} -> {new_state}")
    self.state = new_state

# 2. Log state changes
def transition_to(self, new_state):
    old_state = self.state
    self.state = new_state
    logger.info(f"State changed: {old_state} -> {new_state}")

# 3. Use enums for states
from enum import Enum

class OrderState(Enum):
    PENDING = 'pending'
    PAID = 'paid'
    SHIPPED = 'shipped'

# 4. Separate concerns
# State machine handles transitions
# Business logic in separate methods

# 5. Test all transitions
def test_order_transitions():
    order = Order()
    assert order.state == 'PENDING'
    order.pay()
    assert order.state == 'PAID'
    order.ship()
    assert order.state == 'SHIPPED'

# 6. Handle concurrent transitions
# Use database locks or optimistic locking
UPDATE orders SET status = 'shipped' WHERE id = 123 AND status = 'paid';
```

## State Machine Diagram

```
        ┌─────────┐
        │ Pending │
        └────┬────┘
             │
      ┌──────┴──────┐
      │             │
   pay()        cancel()
      │             │
      ▼             ▼
 ┌────────┐   ┌───────────┐
 │  Paid  │   │ Cancelled │
 └────┬───┘   └───────────┘
      │
   ship()
      │
      ▼
 ┌──────────┐
 │ Shipped  │
 └────┬─────┘
      │
  deliver()
      │
      ▼
 ┌───────────┐
 │ Delivered │
 └───────────┘
```

## Event-Driven State Machine

```python
class EventDrivenOrder:
    def __init__(self):
        self.state = 'PENDING'
        self.events = []

    def on_event(self, event):
        self.events.append(event)

        if event == 'PAYMENT_RECEIVED' and self.state == 'PENDING':
            self.state = 'PAID'
        elif event == 'ITEM_SHIPPED' and self.state == 'PAID':
            self.state = 'SHIPPED'
        elif event == 'ITEM_DELIVERED' and self.state == 'SHIPPED':
            self.state = 'DELIVERED'
        elif event == 'CANCELLED':
            if self.state in ['PENDING', 'PAID']:
                self.state = 'CANCELLED'

    def get_history(self):
        return self.events

# Usage
order = EventDrivenOrder()
order.on_event('PAYMENT_RECEIVED')
print(order.state)  # PAID
order.on_event('ITEM_SHIPPED')
print(order.state)  # SHIPPED
print(order.get_history())  # ['PAYMENT_RECEIVED', 'ITEM_SHIPPED']
```
