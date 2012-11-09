# set path to app that will be used to configure unicorn, 
# note the trailing slash in this example
@dir = "#{Dir.pwd}/"

worker_processes 2
working_directory @dir

timeout 30

# Specify path to socket unicorn listens to, 
# we will use this in our nginx.conf later
listen "/tmp/unicorn/sockets/unicorn.sock", :backlog => 64

# Set process id path
pid "/var/run/unicorn/pids/unicorn.pid"

# Set log file paths
stderr_path "/var/log/unicorn/unicorn.stderr.log"
stdout_path "/var/log/unicorn/unicorn.stdout.log"