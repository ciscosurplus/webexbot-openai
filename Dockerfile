FROM python:3.9
RUN mkdir /temp \
  && cd /temp \
  && mkdir package \
  && pip3 install --target ./package openai \
  && pip3 install --target ./package webexteamssdk
  
