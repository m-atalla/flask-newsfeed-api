from flask import Flask, jsonify, request
from db import MySQLConnection, config
import click
from flask_bcrypt import bcrypt

app = Flask(__name__)


@app.cli.command("init_db")
def init_db():
    with open("schema.sql", "r", encoding="utf-8") as f:
        schema = f.read().format(config["DB_NAME"])
        with MySQLConnection() as db:
            for _ in db.cursor.execute(schema, multi=True):
                pass
            click.echo("Schema statements executed.")


@app.cli.command("seed_user")
@click.argument("email", default="test@example.com")
def seed_user(email):
    stmt = """
    INSERT INTO users (name, email, password)
    VALUES (%s, %s, %s)
    """
    hashed_password = bcrypt.hashpw(
        "password".encode("utf-8"), bcrypt.gensalt()
    )

    user_data = ("test", email, hashed_password)

    with MySQLConnection() as db:
        db.cursor.execute(stmt, user_data)
        user_id = db.cursor.lastrowid
        click.echo(f"User created. ({user_id=})")


@app.post("/posts")
def store_post():
    content = request.json.get("content")
    user_id = request.json.get("user_id")

    if not content or not user_id:
        return jsonify({
            "message": "Fields `content` and `user_id` are required."
        }), 400

    stmt = "INSERT INTO posts (content, user_id) VALUES (%s, %s)"
    with MySQLConnection() as db:
        db.cursor.execute(stmt, (content, user_id))
        post_id = db.cursor.lastrowid

    return jsonify({"message": "Post added", "post_id": post_id}), 201


@app.put("/posts/<int:post_id>")
def update_post(post_id):
    content = request.json.get("content")

    if not content:
        return jsonify({"message": "Field `content` is required."}), 400

    select_stmt = "SELECT * FROM posts WHERE id = %s"
    update_stmt = "UPDATE posts SET content = %s WHERE id = %s"
    with MySQLConnection() as db:
        db.cursor.execute(select_stmt, (post_id,))
        post = db.cursor.fetchone()
        if not post:
            return jsonify({
                "message": f"Post with ID {post_id} is not found"
            }), 404
        db.cursor.execute(update_stmt, (content, post_id))

    return jsonify({"message": "Post updated"}), 200


@app.get("/posts/<int:post_id>")
def show_post(post_id: int):
    with MySQLConnection() as db:
        db.cursor.execute(
            "SELECT content FROM posts WHERE id = %s", (post_id,))
        post = db.cursor.fetchone()

    if post is None:
        return jsonify({
            "message": f"Post with ID {post_id} is not found"
        }), 404

    return jsonify({
        "post": post
    }), 200


@app.delete("/posts/<int:post_id>")
def delete_post(post_id):
    select_stmt = "SELECT * FROM posts WHERE id = %s"
    delete_stmt = "DELETE FROM posts WHERE id = %s"
    with MySQLConnection() as db:
        db.cursor.execute(select_stmt, (post_id,))
        post = db.cursor.fetchone()
        if not post:
            return jsonify({
                "message": f"Post with ID {post_id} is not found"
            }), 404
        db.cursor.execute(delete_stmt, (post_id,))

    return jsonify({"message": "Post deleted"}), 200
