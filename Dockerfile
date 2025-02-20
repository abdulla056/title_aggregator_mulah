# Use a Node.js base image
FROM ghcr.io/puppeteer/puppeteer:latest

# Set the working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the application
COPY . .

# Expose the port
EXPOSE 3000

# Start the application
CMD ["node", "blog-scraper.js"]

# ... other Dockerfile instructions

USER root  # Switch to root user temporarily

RUN chown -R $UID:$GID /app

USER appuser # Switch back to a non-root user (if applicable)

# ... other Dockerfile instructions, including npm install