import os
from flask import Flask, jsonify, request
from pymongo import MongoClient

app = Flask(__name__)

# Use environment variable for MongoDB connection string
mongo_db_uri = os.getenv('MONGO_DB_URI', 'mongodb://root:example@mongodb:27017/')
client = MongoClient(mongo_db_uri)
db = client.customerDB
customers = db.customers


@app.route('/list_customers', methods=['GET'])
def list_customers():
    all_customers = customers.find()
    result = []
    for customer in all_customers:
        customer["_id"] = str(customer["_id"])  # Convert ObjectId to string
        result.append(customer)
    return jsonify(result)

@app.route('/list_disabled_customers', methods=['GET'])
def list_disabled_customers():
    disabled_customers = customers.find({"status": "disabled"})
    result = []
    for customer in disabled_customers:
        customer["_id"] = str(customer["_id"])  # Convert ObjectId to string
        result.append(customer)
    return jsonify(result)

@app.route('/delete_disabled_customers', methods=['POST'])
def delete_disabled_customers():
    disabled_customers = customers.find({"status": "disabled"})
    result = []
    for customer in disabled_customers:
        delete_result = customers.delete_one({"customer_id": customer["customer_id"]})
        result.append({
            "customer_id": customer["customer_id"],
            "status": "success" if delete_result.deleted_count > 0 else "failed"
        })
    return jsonify(result)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

