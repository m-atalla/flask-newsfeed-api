# Flask Newsfeed API

## Project Setup
### Prerequisites
1. **Python 3.10+** 
1. **MySQL or MariaDB** server running

### Steps to Setup the Project

#### 1. Clone the Repository

```bash
git clone git@github.com:m-atalla/flask-newsfeed-api.git
cd newsfeed-api
```

#### 2. Setup Environment Variables
Use the provided `.env.example` and override its variables for to suit your
current environment.
```bash
cp .env.example .env
```

#### 3. Make virtual environment and install dependencies
```bash
pip -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

#### 4. Run database schema and seed a test user.
```bash
flask init_db
flask seed_user
```

#### 5. Run the development server
```bash
flask run
```

## Testing Endpoints
This service follows the REST conventions and uses the proper HTTP verbs for 
managing the resource `post`.

Use an HTTP client for testing, or use the following examples with curl:

### Get a post
```bash
curl -X GET http://127.0.0.1:5000/posts/1
```
### Add a new post
```bash
curl -X POST http://127.0.0.1:5000/posts \
    -H "Content-Type: application/json" \
    -d '{
        "user_id": 1,
        "content": "New post!"
    }'
```

### Update an existing post
```bash
curl -X PUT http://127.0.0.1:5000/posts/1 \
    -H "Content-Type: application/json" \
    -d '{
        "user_id": 1,
        "content": "Updated post content."
    }'
```

### Delete a post
```bash
curl -X DELETE http://127.0.0.1:5000/posts/1
```
