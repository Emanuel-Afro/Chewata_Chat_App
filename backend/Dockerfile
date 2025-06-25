FROM node:18

# Set working directory
WORKDIR /app

# Copy only package files first for better caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the backend code
COPY . .

# If you're using nodemon
###RUN npm install -g nodemon

# Expose the backend port
EXPOSE 5000

# Start the app
CMD ["npm", "start"]
