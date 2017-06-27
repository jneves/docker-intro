# Use an official nginx runtime as a base image
FROM nginx:latest

# Set the working directory to the static page dir
WORKDIR /usr/share/nginx/html

# Copy the current directory contents into the container at /usr/share/nginx/html
ADD . /usr/share/nginx/html

# Make port 80 available to the world outside this container
EXPOSE 80

# Run app.py when the container launches
CMD /usr/sbin/nginx -g 'daemon off;'
