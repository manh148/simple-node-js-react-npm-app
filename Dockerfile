FROM node:lts-buster-slim
EXPOSE 3000
RUN npm install && npm run build

