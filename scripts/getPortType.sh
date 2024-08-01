#!/bin/bash

declare -A port_map
port_map[21]="ftp"
port_map[22]="ssh"
prot_map[23]="telnet"
port_map[25]="smtp"
port_map[80]="http"
port_map[161]="snmp"
port_map[389]="ldap"
port_map[443]="https"
port_map[445]="smb"
port_map[3389]="rdp"

echo ${port_map[$1]}
