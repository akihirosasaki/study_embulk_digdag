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
COPY study_embulk_digdag_k8s/ /tmp/project/
RUN chmod -R +x /tmp/project/shell/

# 環境変数設定(必要に応じてデータベースの接続情報を環境変数に格納する)
ENV GOOGLE_APPLICATION_CREDENTIALS "/tmp/project/secret/develop-test-k8s-asasaki.json"
ENV AWS_ACCESS_KEY_ID ENV["access_key_id"]
ENV AWS_SECRET_ACCESS_KEY ENV["secret_access_key"]