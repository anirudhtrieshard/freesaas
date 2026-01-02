#!/bin/bash

echo "Environment Setup Helper"
echo "========================"

if [ -f .env ]; then
    echo "Warning: .env file already exists!"
    read -p "Overwrite? (y/N): " confirm
    if [ "$confirm" != "y" ]; then
        echo "Aborted."
        exit 0
    fi
fi

echo ""
echo "Creating .env from template..."
cp .env.example .env

echo ""
echo "Please provide the following values:"

read -p "Server Name (e.g., myserver): " SERVER_NAME
read -p "Server IP (e.g., 192.168.1.100): " SERVER_IP
read -p "Domain Name (e.g., example.com): " DOMAIN_NAME
read -sp "PostgreSQL Password: " POSTGRES_PASSWORD
echo ""
read -sp "Grafana Admin Password: " GRAFANA_PASSWORD
echo ""

sed -i "s/SERVER_NAME=.*/SERVER_NAME=$SERVER_NAME/" .env
sed -i "s/SERVER_IP=.*/SERVER_IP=$SERVER_IP/" .env
sed -i "s/DOMAIN_NAME=.*/DOMAIN_NAME=$DOMAIN_NAME/" .env
sed -i "s/POSTGRES_PASSWORD=.*/POSTGRES_PASSWORD=$POSTGRES_PASSWORD/" .env
sed -i "s/GRAFANA_ADMIN_PASSWORD=.*/GRAFANA_ADMIN_PASSWORD=$GRAFANA_PASSWORD/" .env

echo ""
echo ".env file created successfully!"
echo "You can edit it manually: nano .env"
