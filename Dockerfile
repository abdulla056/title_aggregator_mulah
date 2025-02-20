# Use a Node.js base image (Alpine for smaller size)
FROM node:16-alpine  
# Or a later version

# Create app directory (Good practice)
WORKDIR /app

# Copy package.json and package-lock.json (if it exists) FIRST
COPY package*.json ./

RUN apt-get update && apt-get install -y wget unzip \
    && wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install -y ./google-chrome-stable_current_amd64.deb \
    && rm google-chrome-stable_current_amd64.deb

# Install dependencies
RUN npm install

# Copy the rest of your application code
COPY . .

# Set the user (Important - use the node user)
USER node

# Expose the port
EXPOSE 3000

# Command to start your application
CMD ["node", "blog-scraper.js"]