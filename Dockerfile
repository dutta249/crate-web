FROM ubuntu:20.04

# Update the package repository and install any necessary packages
RUN apt update  && \
    apt-get upgrade -y && \
    apt-get install -y curl && \
    apt-get install -y build-essential

# Install Node.js 15
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

# Set the working directory
WORKDIR /app


# Copy the application files to the container
COPY . .

RUN ls -lrt &&\
    ls -a
    
RUN npm install && \
    npm install -g webpack && \
    npm install --save-dev webpack

RUN ls -lrt &&\
    ls -a

EXPOSE 3000 

# Start the application
CMD ["npm", "start"]