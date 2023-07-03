InputStream is = connection.getInputStream();
        BufferedReader responseReader = new BufferedReader(new InputStreamReader(is));
          
        if ((responseData = responseReader.readLine()) != null) {
          JSONObject obj = new JSONObject(responseData);
          String txnToken = obj.getJSONObject("body").getString("txnToken");
          JSONObject bodyres = obj.getJSONObject("body");
          String resultstatus = bodyres.getJSONObject("resultInfo").getString("resultStatus");
          String resultMsg = bodyres.getJSONObject("resultInfo").getString("resultMsg");
          if(resultstatus.equals("S")) {
            resultdata.put("success", true);
            resultdata.put("orderId", generatedOrderID);
            resultdata.put("txnToken", txnToken);
            resultdata.put("amount", amount);
            resultdata.put("message", resultMsg);
          }else {
            resultdata.put("success", false);
            resultdata.put("orderId", generatedOrderID);
            resultdata.put("amount", amount);
            resultdata.put("message", resultMsg);
          }
       }
       responseReader.close();
     } catch (Exception exception) {
         exception.printStackTrace();
     }
     return resultdata;
   }

public static Map TransactionStatus() throws Exception {
  /* initialize an object */
  JSONObject paytmParams = new JSONObject();

  /* body parameters */
  JSONObject body = new JSONObject();

  /* Find your MID in your Paytm Dashboard at https://dashboard.paytm.com/next/apikeys */
  body.put("mid", PAYTM_MID);

  /* Enter your order id which needs to be check status for */
  body.put("orderId", "YOUR_ORDERID_Here");
  
  String checksum = PaytmChecksum.generateSignature(body.toString(), PAYTM_MERCHANT_KEY);
  /* head parameters */
  JSONObject head = new JSONObject();

  /* put generated checksum value here */
  head.put("signature", checksum);

  /* prepare JSON string for request */
  paytmParams.put("body", body);
  paytmParams.put("head", head);
  String post_data = paytmParams.toString();
  URL url = new URL(PAYTM_ENVIRONMENT+"/v3/order/status");
  Map resultdata =  new HashMap<>();
  try {
    HttpURLConnection connection = (HttpURLConnection) url.openConnection();
    connection.setRequestMethod("POST");
    connection.setRequestProperty("Content-Type", "application/json");
    connection.setDoOutput(true);

    DataOutputStream requestWriter = new DataOutputStream(connection.getOutputStream());
    requestWriter.writeBytes(post_data);
    requestWriter.close();
    String responseData = "";
    InputStream is = connection.getInputStream();
    BufferedReader responseReader = new BufferedReader(new InputStreamReader(is));
