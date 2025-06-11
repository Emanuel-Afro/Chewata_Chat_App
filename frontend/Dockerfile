#Frontend Dockerfile
FROM node:latest
WORKDIR /app
COPY package*.json ./
RUN npm install --legacy-peer-deps

COPY . .

ENV NODE_OPTIONS=--openssl-legacy-provider

#RUN npm run build
CMD [ "npm", "start"]
