from flask import Flask, request
import os
import shutil

from phonemizer.backend import EspeakBackend
from phonemizer.backend.espeak.wrapper import EspeakWrapper
from phonemizer.separator import Separator, default_separator

app = Flask(__name__)


@app.get("/")
def hello():
    """Return a friendly HTTP greeting."""
    who = request.args.get("who", default="World")
    return f"Hello {who}!\n"

@app.get("/ipa")
def return_ipa():
    text = request.args.get("text", default="Hello")
    backend = EspeakBackend('en-us')
    out = backend.phonemize([text], default_separator, True)
    return str(out)

if __name__ == "__main__":
    # Development only: run "python main.py" and open http://localhost:8080
    # When deploying to Cloud Run, a production-grade WSGI HTTP server,
    # such as Gunicorn, will serve the app.
    app.run(host="localhost", port=8080, debug=True)
