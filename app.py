import PaytmChecksum
import config
import datetime
from flask import Flask, render_template, request

app = Flask(__name__)

@app.route('/')
def app_create():
    token = config.getTransactionToken()
    print(token)
    return render_template('index.html', mid=config.PAYTM_MID,amount=config.amount,orderid=config.order_id,env=config.PAYTM_ENVIRONMENT,token=token)

@app.route('/callback', methods=['POST'])
def app_callback():
    data = dict()
    data = request.form.to_dict(flat=True)
    if data:
         checksum = data['CHECKSUMHASH']
         data.pop('CHECKSUMHASH', None)

         #verify checksum
         verifySignature = PaytmChecksum.verifySignature(data, config.PAYTM_MERCHANT_KEY, checksum)
         text_error = ''
         text_success = ''

         if verifySignature:
           text_success = "Checksum is verified.Transaction details are below"
         else:
          text_error = "Checksum is not verified."
    else :
     text_error = "Empty POST Response."

    return render_template('callback.html', data=data, text_success=text_success , text_error=text_error, verifySignature=verifySignature)

@app.route('/txnstatus', methods=['GET'])
def app_txnstatus():
    data = dict()
    data = request.form.to_dict(flat=True)
    result = config.transactionStatus()
    print(result)

    return render_template('txnstatus.html', data=data,result=result)

if __name__ == '__main__':
    app.run()