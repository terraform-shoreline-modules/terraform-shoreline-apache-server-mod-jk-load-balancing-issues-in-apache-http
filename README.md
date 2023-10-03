
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Mod_jk Load Balancing Issues in Apache HTTP.
---

This incident type refers to a problem with the load balancing functionality of the Apache HTTP server when using the mod_jk connector. This can cause issues with distributing incoming traffic across multiple servers, resulting in reduced performance or even downtime for the affected services. It is important to address and resolve these issues as quickly as possible to minimize impact on users and ensure the stability of the system.

### Parameters
```shell
export MOD_JK="PLACEHOLDER"

export PORT="PLACEHOLDER"

export WORKER_NODE_1="PLACEHOLDER"

export WORKER_NODE_2="PLACEHOLDER"

export LOADBALANCER="PLACEHOLDER"

export DESIRED_LOAD_BALANCING_ALGORITHM="PLACEHOLDER"

export PATH_TO_MOD_JK_CONFIGURATION_FILE="PLACEHOLDER"
```

## Debug

### Check if mod_jk is enabled in Apache HTTP
```shell
apachectl -M | grep ${MOD_JK}
```

### Check if the load balancer is configured correctly
```shell
grep -r '<LoadBalancer' /etc/httpd/conf.d/
```

### Check the status of the worker nodes
```shell
curl http://${WORKER_NODE_1}:${PORT}/status

curl http://${WORKER_NODE_2}:${PORT}/status
```

### Check the Apache error log for any relevant error messages
```shell
tail -n 100 /var/log/httpd/error_log | grep ${MOD_JK}
```

### Check the Apache access log for any relevant traffic patterns
```shell
tail -n 100 /var/log/httpd/access_log | grep ${LOADBALANCER}
```

### Check the network connectivity between the load balancer and worker nodes
```shell
ping -c 5 ${WORKER_NODE_1}

ping -c 5 ${WORKER_NODE_2}
```

## Repair

### Restart Apache HTTP server to see if the issue is resolved temporarily.
```shell


#!/bin/bash



# Stop the Apache HTTP server

sudo systemctl stop apache2



# Wait for a few seconds to ensure that all services are stopped

sleep 5



# Start the Apache HTTP server

sudo systemctl start apache2



# Check the status of the Apache HTTP server

sudo systemctl status apache2


```

### Adjust the load balancing algorithm used by mod_jk to better suit the specific needs of the system and its traffic patterns.
```shell


#!/bin/bash



# Define variables

LOAD_BALANCER_CONF=${PATH_TO_MOD_JK_CONFIGURATION_FILE}

NEW_ALGORITHM=${DESIRED_LOAD_BALANCING_ALGORITHM}



# Stop Apache HTTP server

systemctl stop httpd



# Update mod_jk configuration file with new load balancing algorithm

sed -i "s/^worker.loadbalancer.type=.*$/worker.loadbalancer.type=$NEW_ALGORITHM/" $LOAD_BALANCER_CONF



# Start Apache HTTP server

systemctl start httpd


```