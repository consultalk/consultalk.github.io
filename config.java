package paytm_jscheckoutjava;
import com.paytm.pg.merchant.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;
import org.json.JSONObject;

public class Config {

  public final static String PAYTM_MID="JETGQf36364799695672";
  public final static String PAYTM_MERCHANT_KEY="AldlL3&ekM#FjUlI";

  public final static String PAYTM_WEBSITE="WEBSTAGING";
  //Replace base url on basis of your site
  public final static String PAYTM_CALLBACK_URL="http://localhost:8080/jscheckoutjava/callback.jsp";
  // for staging
  public final static String PAYTM_ENVIRONMENT="https://securegw-stage.paytm.in";
  // for production env
  // public final static String PAYTM_ENVIRONMENT="https://securegw.paytm.in";

    public static Map<String, Object> getTransactionToken() throws Exception {
    Timestamp timestamp = new Timestamp(System.currentTimeMillis());
    String generatedOrderID = "PYTM_BLINK_"+timestamp.getTime();
    double amount = 1.00;
      
      /* initialize an object */
      JSONObject paytmParams = new JSONObject();

      /* body parameters */
      JSONObject body = new JSONObject();

      /* for custom checkout value is 'Payment' and for intelligent router is 'UNI_PAY' */
      body.put("requestType","Payment");

      /* Find your MID in your Paytm Dashboard at https://dashboard.paytm.com/next/apikeys */
      body.put("mid", PAYTM_MID);

      /* Find your Website Name in your Paytm Dashboard at https://dashboard.paytm.com/next/apikeys */
      body.put("websiteName", PAYTM_WEBSITE);

      /* Enter your unique order id */
      body.put("orderId", generatedOrderID);

      /* on completion of transaction, we will send you the response on this URL */
      body.put("callbackUrl", PAYTM_CALLBACK_URL);

      /* initialize an object for txnAmount */
      JSONObject txnAmount = new JSONObject();

      /* Transaction Amount Value */
      txnAmount.put("value", amount);

      /* Transaction Amount Currency */
      txnAmount.put("currency", "INR");

      /* initialize an object for userInfo */
      JSONObject userInfo = new JSONObject();

      /* unique id that belongs to your customer */
      userInfo.put("custId", "cust_"+timestamp.getTime());

      /* put txnAmount object in body */
      body.put("txnAmount", txnAmount);

      /* put userInfo object in body */
      body.put("userInfo", userInfo);

      /**
      * Generate checksum by parameters we have in body
      * You can get Checksum JAR from https://developer.paytm.com/docs/checksum/
      * Find your Merchant Key in your Paytm Dashboard at https://dashboard.paytm.com/next/apikeys 
      */

      String checksum = PaytmChecksum.generateSignature(body.toString(),PAYTM_MERCHANT_KEY);
      /* head parameters */
      JSONObject head = new JSONObject();

      /* put generated checksum value here */
      head.put("signature", checksum);

      /* prepare JSON string for request */
      paytmParams.put("body", body);
      paytmParams.put("head", head);
      String post_data = paytmParams.toString();

      URL url = new URL(PAYTM_ENVIRONMENT+"/theia/api/v1/initiateTransaction?mid="+PAYTM_MID+"&orderId="+generatedOrderID);

      String responseData = "";
      /* result parameters */

      Map<String, Object> resultdata =  new HashMap<>();

      try {
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("POST");
        connection.setRequestProperty("Content-Type", "application/json");
        connection.setDoOutput(true);

        DataOutputStream requestWriter = new DataOutputStream(connection.getOutputStream());
        requestWriter.writeBytes(post_data);
        requestWriter.close();
