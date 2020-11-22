FROM node

RUN apt update && apt install git
RUN git clone https://github.com/gilbitron/Raneto.git /wiki/

WORKDIR /wiki/
RUN npm install && npm run gulp

EXPOSE 3000
CMD [ "npm", "start" ]
