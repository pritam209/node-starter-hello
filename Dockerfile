FROM node:22-alpine

#define working dir inside he container
WORKDIR /app

Copy package.json .

#install dep
RUN npm install

#copy code in container

COPY . .

#install dep
#RUN npm install 

# build your app
RUN npm  run build

#start the application

CMD ["node","dist/main"]

