

#!/bin/bash



# Stop the Apache HTTP server

sudo systemctl stop apache2



# Wait for a few seconds to ensure that all services are stopped

sleep 5



# Start the Apache HTTP server

sudo systemctl start apache2



# Check the status of the Apache HTTP server

sudo systemctl status apache2