from fastapi import FastAPI, HTTPException
from neo4j import GraphDatabase
import os
from dotenv import load_dotenv

# Load environment variables from the .env file
load_dotenv()

app = FastAPI(
    title="PosturePrompt API",
    description="AI-powered Zero Trust assessment engine for Microsoft 365.",
    version="1.0.0"
)

# Neo4j Database Connection Setup
NEO4J_URI = os.getenv("NEO4J_URI", "bolt://neo4j:7687")
NEO4J_USER = os.getenv("NEO4J_USER", "neo4j")
NEO4J_PASSWORD = os.getenv("NEO4J_PASSWORD", "PosturePromptSecure2026!")

class Neo4jConnection:
    def __init__(self, uri, user, pwd):
        self.__uri = uri
        self.__user = user
        self.__pwd = pwd
        self.__driver = None
        try:
            self.__driver = GraphDatabase.driver(self.__uri, auth=(self.__user, self.__pwd))
        except Exception as e:
            print("Failed to create the driver:", e)
        
    def close(self):
        if self.__driver is not None:
            self.__driver.close()
            
    def verify_connectivity(self):
        try:
            self.__driver.verify_connectivity()
            return True
        except Exception as e:
            return False

# Initialize the database connection
db = Neo4jConnection(NEO4J_URI, NEO4J_USER, NEO4J_PASSWORD)

@app.get("/")
def read_root():
    return {"message": "Welcome to the PosturePrompt API. Engine is running."}

@app.get("/health")
def health_check():
    """Check if the API and Database are communicating."""
    db_status = db.verify_connectivity()
    if db_status:
        return {"status": "healthy", "database": "connected"}
    else:
        raise HTTPException(status_code=503, detail="Database connection failed")

# Remember to close the database connection when the app shuts down
@app.on_event("shutdown")
def shutdown_event():
    db.close()