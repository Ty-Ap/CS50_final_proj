#!/bin/python3

import sqlite3, os, sys, json

# Config check
if  os.getenv('CONFIG') == None:
    print("This script cannot be run standalone, enviroment variables need to be set via config.sh")
    sys.exit(1)

#Var definitions
DB_FILE = os.environ['DB_FILE']
method = sys.argv[1]
tool = sys.argv[2]
data = sys.argv[3:]

BASE_PATH = os.environ['BASE_PATH']

connection = sqlite3.connect(f"{BASE_PATH}/{DB_FILE}")
cursor = connection.cursor()

#connection.set_trace_callback(print)

def display_data():
    cursor.execute("SELECT ip FROM targets;")
    data = cursor.fetchall()
    for ip in data:
        cursor.execute("SELECT * FROM targets WHERE ip=?;",ip);
        target = cursor.fetchone()
        print(f"\033[1;36m{target[1]} \033[0;33m({target[0]})")
        for port in cursor.execute("SELECT * FROM ports WHERE ip=?;",ip):
            print(f"\033[0;32mPort {port[1]}:\033[0;m {port[2]}")
        print()  
    

def field_exists(col,val):
    cursor.execute(f"SELECT * FROM targets WHERE {col}=?;", (val,))
    if cursor.fetchone():
        return True
    else:
        return False

def port_exists(ip,port):
    cursor.execute("SELECT * FROM ports WHERE ip=? AND port=?;",(ip,port))
    if cursor.fetchone():
        return True
    else:
        return False

def domain_null(ip):
    cursor.execute("SELECT domain FROM targets WHERE ip=?;",(ip,))
    if cursor.fetchone():
        return False
    else:
        return True

def update_target(ip,domain):
    cursor.execute("UPDATE targets SET domain=? WHERE ip=?;",(domain,ip))
    connection.commit()

def update_port(ip,port,service):
    cursor.execute("UPDATE ports SET service=? WHERE ip=? AND port=?;",(service,ip,port))
    connection.commit()

def insert_target(ip, domain):
    cursor.execute("INSERT INTO targets (ip,domain) VALUES (?,?);", (ip,domain))
    connection.commit()

def insert_port(ip, port, service):
    cursor.execute("INSERT INTO ports (ip,port,service) VALUES (?,?,?);", (ip,port,service))
    connection.commit()

if method == "put":
    if tool == "ip":
        ip = data[0]
        domain = data[1]
        if field_exists("ip",ip) and domain_null(ip):
            update_target(ip,domain)
        elif not field_exists("ip",ip):
            insert_target(ip,domain)

    elif tool == "map":
        ip = data[0]
        port = data[1]

        if not field_exists("ip",ip):
            insert_target(ip,None)
        if not port_exists(ip,port):
            insert_port(ip,port,None)

    elif tool == "service":
        ip = data[0]
        port = data[1]
        service = data[2]
        if not field_exists("ip",ip):
            insert_target(ip,None)
        if port_exists(ip,port):
            update_port(ip,port,service)
        else:
            insert_port(ip,port,service)

    else:
        print(f"Error: {tool} not found. Must be 'ip', 'map', or 'service'")
elif method == "get":
    if tool == "all":
        display_data()
        

else:
    print(f"Error: Method {method} not supported")


connection.close()
