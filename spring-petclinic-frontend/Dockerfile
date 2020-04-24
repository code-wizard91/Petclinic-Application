# base image
FROM node:12.2.0
WORKDIR /app
COPY package.json /app/package.json
RUN npm install
RUN npm install -g @angular/cli@latest

# add app
COPY . /app
# start app
#CMD ["ng","serve","--host", "0.0.0.0"]
CMD ng serve --host 0.0.0.0 --port 4200 --disableHostCheck true
