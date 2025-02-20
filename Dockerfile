# Use an official Node.js image as base
FROM node:18-bullseye

# Create app directory (Good practice)
WORKDIR /app

# Copy package.json and package-lock.json (if it exists) FIRST
COPY package*.json ./

# Install dependencies and Chrome
RUN apt-get update && apt-get install -y wget gnupg ca-certificates \
    && wget -qO- https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /usr/share/keyrings/google-chrome-keyring.gpg \
    && echo 'deb [signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update && apt-get install -y google-chrome-stable

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