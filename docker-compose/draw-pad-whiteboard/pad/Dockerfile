FROM node

RUN apt update && apt install git
RUN git clone https://github.com/petercunha/Pad.git /pad/

WORKDIR /pad/
RUN npm install

EXPOSE 3000
CMD [ "npm", "start" ]
