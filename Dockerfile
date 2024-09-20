# ベースイメージとしてJupyter Notebookの公式イメージを使用
# FROM nvidia/cuda:11.2.2-cudnn8-runtime-ubuntu20.04
FROM ubuntu:20.04

# 必要なパッケージをインストール
USER root
RUN apt-get update && apt-get install -y \
    openssl

# 証明書のディレクトリを作成
RUN mkdir /etc/ssl/notebook

# コンテナの設定
USER $NB_UID
COPY jupyter_notebook_config.py /etc/jupyter/

WORKDIR /app

# Use bash shell
SHELL ["/bin/bash", "-c"]

# Install necessary dependencies and python3-pip
RUN apt-get update && \
    apt-get install -y python3-pip && \
    pip3 install --upgrade pip

# Install NVIDIA container toolkit
# RUN apt-get install -y nvidia-container-toolkit

# Copy the requirements file and install Python dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# 起動スクリプトの設定
CMD ["jupyter", "notebook" ,"--NotebookApp.certfile=/etc/ssl/notebook/notebook.pem", "--NotebookApp.keyfile=/etc/ssl/notebook/notebook-key.pem", "--NotebookApp.ip=0.0.0.0", "--NotebookApp.port=8888", "--NotebookApp.open_browser=False"]

