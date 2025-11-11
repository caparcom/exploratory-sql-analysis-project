import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
import pandas as pd


# Load environment variables
load_dotenv()

# Read DB path from environment variable
DB_PATH = os.getenv('DB_PATH', './data/database.db')  # fallback to default
DB_URL = f'sqlite:///{DB_PATH}'

# Connect to the existing SQLite database
def connect():
    try:
        engine = create_engine(DB_URL)
        engine.connect()
        print("✅ Connected to existing SQLite database.")
        return engine
    except Exception as e:
        print(f"❌ Error connecting to database: {e}")
        return None

# Run student-defined queries from queries.sql
def run_queries_from_file(engine, filepath):
    try:
        with open(filepath, 'r') as file:
            content = file.read()
        queries = [q.strip() for q in content.split(';') if q.strip()]
        for i, query in enumerate(queries, start=1):
            # Remove comment lines from the query. We were leaving them in which was causing the parsing issues.
            query_lines = [
                line for line in query.split('\n') 
                if line.strip() and not line.strip().startswith('--')
            ]
            clean_query = '\n'.join(query_lines).strip()
            # Skip if empty after removing comments
            if not clean_query or not any(c.isalnum() for c in clean_query):
                continue 
            try:
                print(f"\n🔎 Query {i}:\n{clean_query}")
                df = pd.read_sql(clean_query, con=engine)
                print(df)
            except Exception as e:
                print(f"❌ Error in Query {i}: {e}")
    except Exception as e:
        print(f"❌ Error processing queries from {filepath}: {e}")


# Entry point
if __name__ == "__main__":
    engine = connect()
    if engine:
        run_queries_from_file(engine, './src/sql/queries.sql')