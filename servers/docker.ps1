# Define the list of containers
$containers = @("victim-1", "victim-2", "victim-3", "victim-4", "victim-5", "victim-6", "victim-7", "victim-8", "victim-9", "victim-10", "attacker")

# Loop through each container
foreach ($container in $containers) {
    # Start the container
    docker-compose up -d $container

    # Wait for 30 seconds
    Start-Sleep -Seconds 30
}
