FROM node:14.18.1-slim

# 安装最新的chrome开发包和字体，以支持主要字符集(中文，日语，阿拉伯语，希伯来语，泰国语和一些其他)
# 注意: 这安装了必要的库，以使捆绑版本的Chromium、Puppeteer 安装、运行。
RUN set -eux; \
  \
  sed -i "s@http://deb.debian.org@http://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list; \
  sed -i "s@http://security.debian.org@http://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list; \
  \
  apt-get update \
  && apt-get install -y wget gnupg procps vim \
  && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
  && apt-get update \
  && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 \
    --no-install-recommends \
#    && wget --quiet https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -O /usr/sbin/wait-for-it.sh \
#    && chmod +x /usr/sbin/wait-for-it.sh \
  && rm -rf /var/lib/apt/lists/*
