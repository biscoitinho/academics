# Date and Time Handling

## Python datetime

```python
from datetime import datetime, date, time, timedelta

# Current datetime
now = datetime.now()
print(now)  # 2024-01-15 10:30:45.123456

# Current date
today = date.today()
print(today)  # 2024-01-15

# Create specific datetime
dt = datetime(2024, 1, 15, 10, 30, 45)
print(dt)  # 2024-01-15 10:30:45

# Time only
t = time(14, 30, 0)
print(t)  # 14:30:00
```

## Ruby Time

```ruby
require 'time'

# Current time
now = Time.now
puts now  # 2024-01-15 10:30:45 +0000

# Current date
today = Date.today
puts today  # 2024-01-15

# Create specific time
time = Time.new(2024, 1, 15, 10, 30, 45)
puts time
```

## Formatting

### Python

```python
now = datetime.now()

# strftime (datetime to string)
formatted = now.strftime('%Y-%m-%d %H:%M:%S')
print(formatted)  # 2024-01-15 10:30:45

# Common format codes
now.strftime('%Y')  # 2024 (year)
now.strftime('%m')  # 01 (month)
now.strftime('%d')  # 15 (day)
now.strftime('%H')  # 10 (hour 24h)
now.strftime('%I')  # 10 (hour 12h)
now.strftime('%M')  # 30 (minute)
now.strftime('%S')  # 45 (second)
now.strftime('%p')  # AM/PM
now.strftime('%A')  # Monday (day name)
now.strftime('%B')  # January (month name)

# ISO format
now.isoformat()  # 2024-01-15T10:30:45.123456
```

### Ruby

```ruby
now = Time.now

# strftime
formatted = now.strftime('%Y-%m-%d %H:%M:%S')
puts formatted  # 2024-01-15 10:30:45

# Common formats
now.strftime('%Y')  # 2024
now.strftime('%m')  # 01
now.strftime('%d')  # 15
now.strftime('%H')  # 10
now.strftime('%M')  # 30
now.strftime('%S')  # 45
now.strftime('%A')  # Monday
now.strftime('%B')  # January

# ISO format
now.iso8601  # 2024-01-15T10:30:45+00:00
```

## Parsing

### Python

```python
# strptime (string to datetime)
dt_string = '2024-01-15 10:30:45'
dt = datetime.strptime(dt_string, '%Y-%m-%d %H:%M:%S')
print(dt)

# ISO format
dt = datetime.fromisoformat('2024-01-15T10:30:45')

# From timestamp
dt = datetime.fromtimestamp(1705318245)
```

### Ruby

```ruby
# Parse string
dt_string = '2024-01-15 10:30:45'
dt = Time.parse(dt_string)
puts dt

# From timestamp
dt = Time.at(1705318245)
puts dt
```

## Timezones

### Python

```python
from datetime import datetime, timezone
import pytz

# UTC
utc_now = datetime.now(timezone.utc)
print(utc_now)

# Specific timezone
eastern = pytz.timezone('America/New_York')
eastern_time = datetime.now(eastern)
print(eastern_time)

# Convert timezone
utc_dt = datetime.now(timezone.utc)
eastern_dt = utc_dt.astimezone(pytz.timezone('America/New_York'))
print(eastern_dt)

# Naive vs Aware
naive = datetime.now()  # No timezone
aware = datetime.now(timezone.utc)  # With timezone
```

### Ruby

```ruby
require 'time'

# UTC
utc_now = Time.now.utc
puts utc_now

# Specific timezone
require 'active_support/time'
eastern_time = Time.now.in_time_zone('Eastern Time (US & Canada)')
puts eastern_time

# Convert
utc_time = Time.now.utc
eastern_time = utc_time.getlocal('-05:00')
puts eastern_time
```

## Timedelta / Time Arithmetic

### Python

```python
from datetime import timedelta

# Add time
now = datetime.now()
tomorrow = now + timedelta(days=1)
next_week = now + timedelta(weeks=1)
next_hour = now + timedelta(hours=1)

# Subtract time
yesterday = now - timedelta(days=1)

# Difference between dates
dt1 = datetime(2024, 1, 15)
dt2 = datetime(2024, 1, 10)
diff = dt1 - dt2
print(diff.days)  # 5
print(diff.seconds)
print(diff.total_seconds())
```

### Ruby

```ruby
now = Time.now

# Add time
tomorrow = now + (24 * 60 * 60)  # Seconds
next_week = now + (7 * 24 * 60 * 60)

# Subtract time
yesterday = now - (24 * 60 * 60)

# Difference
dt1 = Time.new(2024, 1, 15)
dt2 = Time.new(2024, 1, 10)
diff = dt1 - dt2
puts diff  # Seconds
puts diff / 86400  # Days
```

## Unix Timestamp

```python
# Datetime to timestamp
now = datetime.now()
timestamp = now.timestamp()
print(timestamp)  # 1705318245.123456

# Timestamp to datetime
dt = datetime.fromtimestamp(timestamp)
print(dt)

# UTC timestamp
utc_dt = datetime.utcfromtimestamp(timestamp)
```

```ruby
# Time to timestamp
now = Time.now
timestamp = now.to_i
puts timestamp  # 1705318245

# Timestamp to time
time = Time.at(timestamp)
puts time
```

## Comparing Dates

```python
dt1 = datetime(2024, 1, 15)
dt2 = datetime(2024, 1, 20)

print(dt1 < dt2)  # True
print(dt1 == dt2)  # False
print(dt1 > dt2)  # False

# Is today?
if date.today() == dt1.date():
    print("Today")
```

## Date Ranges

```python
from datetime import date, timedelta

start_date = date(2024, 1, 1)
end_date = date(2024, 1, 10)

current = start_date
while current <= end_date:
    print(current)
    current += timedelta(days=1)

# Or use dateutil
from dateutil.rrule import rrule, DAILY
for dt in rrule(DAILY, dtstart=start_date, until=end_date):
    print(dt.date())
```

## Common Patterns

### Age Calculation

```python
from datetime import date

def calculate_age(birth_date):
    today = date.today()
    age = today.year - birth_date.year
    if (today.month, today.day) < (birth_date.month, birth_date.day):
        age -= 1
    return age

birth = date(1990, 5, 15)
age = calculate_age(birth)
print(f"Age: {age}")
```

### Days Until Event

```python
event_date = datetime(2024, 12, 25)
today = datetime.now()
days_left = (event_date - today).days
print(f"Days until Christmas: {days_left}")
```

### Beginning/End of Month

```python
from datetime import date
from dateutil.relativedelta import relativedelta

today = date.today()

# First day of month
first_day = today.replace(day=1)
print(first_day)

# Last day of month
next_month = today.replace(day=1) + relativedelta(months=1)
last_day = next_month - timedelta(days=1)
print(last_day)

# Or use calendar
import calendar
last_day = date(today.year, today.month, calendar.monthrange(today.year, today.month)[1])
```

### Week Number

```python
today = date.today()
week_number = today.isocalendar()[1]
print(f"Week {week_number}")

# Day of week (0=Monday, 6=Sunday)
day_of_week = today.weekday()
print(day_of_week)

# Day name
day_name = today.strftime('%A')
print(day_name)
```

## Relative Time

```python
# Time ago
from datetime import datetime, timedelta

def time_ago(dt):
    now = datetime.now()
    diff = now - dt

    seconds = diff.total_seconds()

    if seconds < 60:
        return f"{int(seconds)} seconds ago"
    elif seconds < 3600:
        return f"{int(seconds / 60)} minutes ago"
    elif seconds < 86400:
        return f"{int(seconds / 3600)} hours ago"
    else:
        return f"{int(seconds / 86400)} days ago"

past = datetime.now() - timedelta(hours=2)
print(time_ago(past))  # "2 hours ago"
```

## Business Days

```python
import numpy as np

start_date = date(2024, 1, 1)
end_date = date(2024, 1, 31)

# Count business days
business_days = np.busday_count(start_date, end_date)
print(f"Business days: {business_days}")

# Is business day?
is_business_day = np.is_busday(date.today())
```

## Sleep/Wait

```python
import time

# Sleep for seconds
time.sleep(2)  # 2 seconds

# Sleep until specific time
target = datetime.now() + timedelta(seconds=10)
while datetime.now() < target:
    time.sleep(0.1)
```

```ruby
# Sleep for seconds
sleep(2)  # 2 seconds

# Sleep until
target = Time.now + 10
sleep_time = target - Time.now
sleep(sleep_time) if sleep_time > 0
```

## Common Mistakes

```python
# 1. Naive vs Aware datetimes
# ❌ Comparing naive and aware
naive = datetime.now()
aware = datetime.now(timezone.utc)
# naive < aware  # TypeError!

# 2. Timezone assumptions
# ❌ Assuming server timezone
now = datetime.now()  # Local timezone
# ✅ Always use UTC
now = datetime.now(timezone.utc)

# 3. DST (Daylight Saving Time)
# Be careful with timezone arithmetic

# 4. Leap years
# date(2024, 2, 29)  # Valid
# date(2023, 2, 29)  # ValueError!

# 5. Month/day order
# US: MM/DD/YYYY
# Europe: DD/MM/YYYY
# ISO: YYYY-MM-DD (use this!)
```

## Best Practices

```python
# 1. Store in UTC
utc_now = datetime.now(timezone.utc)
db.save(utc_now)

# 2. Convert to local for display
user_tz = pytz.timezone('America/New_York')
local_time = utc_time.astimezone(user_tz)

# 3. Use ISO 8601 format
iso_string = dt.isoformat()  # 2024-01-15T10:30:45+00:00

# 4. Handle timezone-aware datetimes
from datetime import datetime, timezone
now = datetime.now(timezone.utc)

# 5. Use libraries
# dateutil - parsing, relative deltas
# arrow - better API
# pendulum - better timezone handling
```

## Libraries

### arrow (Python)

```python
import arrow

# Current time
now = arrow.now()
print(now)

# Parse
dt = arrow.get('2024-01-15 10:30:45')

# Humanize
print(now.humanize())  # "just now"

past = arrow.now().shift(hours=-2)
print(past.humanize())  # "2 hours ago"

# Shift
tomorrow = now.shift(days=1)
```

### pendulum (Python)

```python
import pendulum

# Current time (timezone aware by default)
now = pendulum.now('UTC')

# Parse
dt = pendulum.parse('2024-01-15 10:30:45')

# Add time
tomorrow = now.add(days=1)

# Difference
diff = tomorrow - now
print(diff.in_hours())

# Humanize
print(now.diff_for_humans())
```
