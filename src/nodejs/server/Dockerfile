FROM node:19-alpine3.16

WORKDIR /usr/src/app

# install app dependencies
COPY package*.json ./
RUN npm install

# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
COPY server.js ./
COPY data/ ./data

EXPOSE 8080
CMD [ "node", "server.js" ]