import mysql.connector
from dotenv import dotenv_values

config = dotenv_values(".env")


class MySQLConnection:
    def __init__(self):
        self.conn = None
        self.cursor = None

    def __enter__(self):
        self.conn = mysql.connector.connect(
            host=config["DB_HOST"],
            user=config["DB_USER"],
            password=config["DB_PASSWORD"],
            database=config["DB_NAME"],
            charset="utf8mb3"
        )

        self.cursor = self.conn.cursor(dictionary=True)

        return self

    def __exit__(self, exc_type, exc_value, traceback):
        if not exc_type:
            self.conn.commit()
        if self.cursor:
            self.cursor.close()
        if self.conn:
            self.conn.close()
        if exc_type:
            print(f"Exception occurred: {exc_type}, {exc_value}")
            return False



