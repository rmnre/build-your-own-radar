FROM nginx:1.25.0

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y ca-certificates curl gnupg

RUN                                                                      \
  mkdir -p /etc/apt/keyrings &&                                          \
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | \
  gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

RUN                                                                                                                     \
  NODE_MAJOR=20 &&                                                                                                      \
  echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | \
  tee /etc/apt/sources.list.d/nodesource.list

RUN                                                                       \
  apt-get update &&                                                       \
  apt-get install -y                                                      \
  libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3    \
  libxss1 libasound2 libxtst6 xauth xvfb g++ make nodejs

WORKDIR /src/build-your-own-radar
COPY package.json ./
COPY package-lock.json ./
RUN npm ci

COPY . ./

# Override parent node image's entrypoint script (/usr/local/bin/docker-entrypoint.sh),
# which tries to run CMD as a node command
ENTRYPOINT []
CMD ["./build_and_start_nginx.sh"]
