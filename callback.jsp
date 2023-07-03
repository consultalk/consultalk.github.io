<%@page import="paytm_jscheckoutjava.Config"%>
<%@page import="java.util.Hashtable"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<% Map<String, Object> result = new HashMap<String, Object>();%>
<% result = Config.getTransactionToken();%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <title>Paytm JS Checkout - Java</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <script src="script.js"></script>    
   
    <script type="application/javascript" crossorigin="anonymous" src="<%=Config.PAYTM_ENVIRONMENT%>/merchantpgpui/checkoutjs/merchants/<%=Config.PAYTM_MID%>.js"></script>

  </head>
  <body>
    <div class="container text-center">
      <div class="shadow p-3 mb-5 bg-white rounded">
        <h2>Paytm JS Checkout - Java</h2>
        <h4>Make Payment</h4>
        <p>You are making payment of ₹<%=result.get("amount")%></p>
        <div class="btn-area">
          <button type="button" id="jsCheckoutPayment" name="submit" class="btn btn-primary">Pay Now</button>
        </div>
      </div>
    </div>
    <script>
      document.getElementById("jsCheckoutPayment").addEventListener("click", function(){
       openJsCheckoutPopup('<%=result.get("orderId")%>','<%=result.get("txnToken")%>', '<%=result.get("amount")%>');
     });
    </script>
  </body>
</html>
