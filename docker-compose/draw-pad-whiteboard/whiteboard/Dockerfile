FROM node

RUN apt update && apt install git
RUN git clone https://github.com/cracker0dks/whiteboard.git /whiteboard/

WORKDIR /whiteboard/
RUN npm install

EXPOSE 8080
CMD [ "npm", "start" ]
