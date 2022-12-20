#!/usr/bin/env python
# -*- coding: utf-8 -*-


import openai
import os
from webexteamssdk import WebexTeamsAPI, Webhook

WEBHOOK_RESOURCE = "messages"
WEBHOOK_EVENT = "created"
webex_api = WebexTeamsAPI()
openai.api_key = os.environ["OPENAI_SECRET_KEY"]


def openai_api(prompt):
    """
    Call the OpenAI API to generate a response to a given prompt.

    Parameters:
        - prompt (str): The message to generate a response for.

    Returns:
        - str: The generated response from the OpenAI API.
    """
    response = openai.Completion.create(
        model="text-davinci-003",
        prompt=prompt,
        temperature=0.6,
        max_tokens=150,
        top_p=1,
        frequency_penalty=1,
        presence_penalty=1
    )

    return response["choices"][0]["text"]


def respond_to_message(webhook, me):
    """
    Respond to a new message in a Webex Teams room.

    Parameters:
        - webhook (obj): The Webhook object representing the new message.
        - me (obj): The Webex Teams person object representing the bot.

    Returns:
        - str: "OK"
    """

    room = webex_api.rooms.get(webhook.data.roomId)
    message = webex_api.messages.get(webhook.data.id)

    if message.personId == me.id:
        return "OK"
    else:
        webex_api.messages.create(
            room.id,
            markdown=openai_api(message.text)
        )

        return "OK"


def lambda_handler(event, context):
    """
    AWS Lambda function handler.

    Parameters:
        - event (dict): The event data passed to the function.
        - context (obj): The context in which the function is being executed.

    Returns:
        - str: "OK"
    """

    me = webex_api.people.me()
    webhook_obj = Webhook(event["body"])

    if (webhook_obj.resource == WEBHOOK_RESOURCE and webhook_obj.event == WEBHOOK_EVENT):
        respond_to_message(webhook_obj, me)
    else:
        print(f"IGNORING UNEXPECTED WEBHOOK:\n{webhook_obj}")

    return "OK"
