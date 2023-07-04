import requests
import json
import PaytmChecksum
import datetime

PAYTM_MID = "JETGQf36364799695672"
PAYTM_MERCHANT_KEY = "AldlL3&ekM#FjUlI"
PAYTM_ENVIRONMENT= 'https://securegw-stage.paytm.in'
PAYTM_WEBSITE= 'WEBSTAGING'

amount= '1.00'
order_id='order_'+str(datetime.datetime.now().timestamp())

def getTransactionToken():
    paytmParams = dict()

    paytmParams["body"] = {
        "requestType"   : "Payment",
        "mid"           : PAYTM_MID,
        "websiteName"   : PAYTM_WEBSITE,
        "orderId"       : order_id,
        "callbackUrl"   : "http://127.0.0.1:5000/callback",
        "txnAmount"     : {
            "value"     : amount,
            "currency"  : "INR",
        },
        "userInfo"      : {
            "custId"    : "CUST_001",
        },
    }

    # Generate checksum by parameters we have in body
    # Find your Merchant Key in your Paytm Dashboard at https://dashboard.paytm.com/next/apikeys 
    checksum = PaytmChecksum.generateSignature(json.dumps(paytmParams["body"]), PAYTM_MERCHANT_KEY)

    paytmParams["head"] = {
        "signature"    : checksum
    }

    post_data = json.dumps(paytmParams)

    url = PAYTM_ENVIRONMENT+"/theia/api/v1/initiateTransaction?mid="+PAYTM_MID+"&orderId="+order_id

    response = requests.post(url, data = post_data, headers = {"Content-type": "application/json"}).json()
    response_str = json.dumps(response)
    res = json.loads(response_str)
    if res["body"]["resultInfo"]["resultStatus"]=='S':
        token=res["body"]["txnToken"]
    else:
        token=""
    return token

def transactionStatus():
    paytmParams = dict()
    paytmParams["body"] = {
        "mid" : PAYTM_MID,
        # Enter your order id which needs to be check status for
        "orderId" : "Your_ORDERId_Here",
    }
    checksum = PaytmChecksum.generateSignature(json.dumps(paytmParams["body"]), PAYTM_MERCHANT_KEY)

    # head parameters
    paytmParams["head"] = {
        "signature"	: checksum
    }

    # prepare JSON string for request
    post_data = json.dumps(paytmParams)

    url = PAYTM_ENVIRONMENT+"/v3/order/status"

    response = requests.post(url, data = post_data, headers = {"Content-type": "application/json"}).json()
    response_str = json.dumps(response)
    res = json.loads(response_str)
    msg="Transaction Status Response"
    return res['body']