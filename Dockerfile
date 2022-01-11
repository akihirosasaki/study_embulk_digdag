FROM openjdk:8-jre-alpine

RUN apk add --no-cache libc6-compat libc-dev python3 python3-dev coreutils tzdata curl && \
  cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
  echo "Asia/Tokyo" > /etc/timezone

# pipをupgradeする
RUN pip3 install --upgrade pip

# pythonのモジュールをインストールする
RUN pip3 install pytz mysql-connector-python google-cloud-bigquery python-dateutil boto3

# py>: でpython3が使えるようにシンボリックリンクさせる
RUN ln -s /usr/bin/python3 /usr/bin/python

# digdag 本体をインストールする
RUN curl -o /bin/digdag --create-dirs -L "https://dl.digdag.io/digdag-latest" \ 
  && chmod +x /bin/digdag 

# Embulk 本体をインストールする
RUN wget -q https://dl.embulk.org/embulk-latest.jar -O /bin/embulk \
  && chmod +x /bin/embulk
 
# 使いたいプラグインを入れる(embulk-input-mysqlなど)
RUN /bin/embulk gem install embulk-input-s3 embulk-output-bigquery

# 実行ファイルのコピー
COPY ./ /tmp/project/
