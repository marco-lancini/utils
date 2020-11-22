FROM node

EXPOSE 3000

RUN mkdir -p /wiki
WORKDIR /wiki
COPY . /wiki

RUN npm install gulp && npm install --production && npm run gulp

CMD ["npm", "start"]
