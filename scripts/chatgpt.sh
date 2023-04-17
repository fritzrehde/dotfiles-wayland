#!/bin/sh

OPENAI_API_KEY="$(pass openai.com/api-key)"

chatblade --openai-api-key "$OPEN_API_KEY" --interactive
