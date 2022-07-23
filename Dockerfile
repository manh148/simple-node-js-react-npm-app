FROM node:lts-buster-slim
EXPOSE 3000
COPY . .
RUN npm install
CMD ["npm","start","&"]
