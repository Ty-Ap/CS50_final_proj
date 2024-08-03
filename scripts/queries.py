#!/bin/python3

import sqlite3, argparse, os, json

def create_tables(conn):
    targets_table = """
    CREATE TABLE IF NOT EXISTS targets (
        ip TEXT PRIMARY KEY,
        domain TEXT,
        build TEXT
    );
    """

    ports_table = """
    CREATE TABLE IF NOT EXISTS ports (
        ip TEXT,
        port INTEGER NOT NULL,
        server TEXT,
        content_type TEXT,
        connection TEXT,
        PRIMARY KEY (ip, port),
        FOREIGN KEY (ip) REFERENCES targets (ip)
        );
    """
    try:
        c = conn.cursor()
        c.execute(targets_table)
        c.execute(ports_table)
    except sqlite3.Error as e:
        print(e)


def create_connection(db_file):
    conn = None
    try:
        conn = sqlite3.connect(db_file)
    except sqlite3.Error as e:
        print(e)
    return conn

def upsert_target(conn, ip, domain=None, build=None):
    query = '''
    INSERT INTO targets (ip, domain, build) 
    VALUES (?,?,?)
    ON CONFLICT (ip) DO
    UPDATE SET 
    domain=COALESCE(excluded.domain, domain),
    build=COALESCE(excluded.build, build)
    '''
    cur = conn.cursor()
    cur.execute(query, (ip, domain, build))
    conn.commit()

def upsert_port(conn, ip, port, server=None, content_type=None, connection=None):
    query = '''
    INSERT INTO ports (ip, port, server, content_type, connection) 
    VALUES (?,?,?,?,?)
    ON CONFLICT (ip, port) DO
    UPDATE SET 
    server=COALESCE(excluded.server, server),
    content_type=COALESCE(excluded.content_type, content_type),
    connection=COALESCE(excluded.connection, connection)
    '''
    cur = conn.cursor()
    cur.execute(query, (ip, port, server, content_type, connection))
    conn.commit()

def get_all_data(conn):
    data = {}
    cur = conn.cursor()

    for row in cur.execute("SELECT * FROM targets"):
        ip = row[0]
        data[ip] = {
            "domain":row[1],
            "build":row[2],
            "ports":{}
        }
    for row in cur.execute("SELECT * FROM ports"):
        ip = row[0]
        port = row[1]
        if ip in data:
            data[ip]["ports"][port] = {
                    "server":row[2],
                    "content_type":row[3],
                    "connection":row[4]
            }

    return json.dumps(data, indent=4)



def main():
    parser = argparse.ArgumentParser(description='Insert, update, or get saved  data')

    parser.add_argument('--ip', help='IP address')
    parser.add_argument('--domain', help='IP address')
    parser.add_argument('--build', help='Build information')
    parser.add_argument('--port', help='Open port number')
    parser.add_argument('--server', help='Server name')
    parser.add_argument('--content_type', help='Content Type')
    parser.add_argument('--connection', help='Connection Type')
    parser.add_argument('--get_all', action='store_true', help='Get all data')

    args = parser.parse_args()

    database = os.environ['DB_FILE']
    conn = create_connection(database)
    if conn is not None:
        create_tables(conn)
        if args.get_all:
            print(get_all_data(conn))
        else:
            if args.ip:
                upsert_target(conn, args.ip, args.domain, args.build)
                if args.port:
                    upsert_port(conn, args.ip, int(args.port), args.server, args.content_type, args.connection)

    else:
        print("Error: Cannot create database connection.")

main()
