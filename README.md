# Postgres Docker Restore

That's a sum of bash script and Dockerfile to generate a restored postgres database docker image.

I'm using alpine: 3 as base image, installing postgresql server and restoring that data to be used in DEVELOPMENT environment.

It's necessary to create the container running nothing but postgresql, execute commands on that running container, then create the image from that.
