FROM ruesin/node:15

RUN set -eux; \
    npm config set registry https://registry.npm.taobao.org && npm config list; \
    npm install -g npm; \
    #npm install -g cnpm --registry=https://registry.npm.taobao.org; \
    #cnpm install --save; \

# RUN npm install canvas express request puppeteer