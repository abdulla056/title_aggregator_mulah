# Use a Node.js base image (Alpine for smaller size)
FROM node:16-alpine  
# Or a later version

# Create app directory (Good practice)
WORKDIR /app

# Copy package.json and package-lock.json (if it exists) FIRST
COPY package*.json ./

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