<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String message = "";
    if (request.getParameter("submitPayment") != null) {
        String patientId = (String) session.getAttribute("user"); // user stores user_id as String
        String cardNumber = request.getParameter("cardNumber");
        String cardHolderName = request.getParameter("cardHolderName");
        String expiryDate = request.getParameter("expiryDate");
        String amount = request.getParameter("amount");

        // Mask card number for storage (store only last 4 digits)
        String digits = cardNumber == null ? "" : cardNumber.replaceAll("\\D", "");
        String masked = digits.length() >= 4 ? "**** **** **** " + digits.substring(digits.length() - 4) : "****";

        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DatabaseConnection.initializeDatabase();

            PreparedStatement ps = conn.prepareStatement("INSERT INTO payments (patient_id, card_number, card_holder_name, expiry_date, cvv, amount) VALUES (?, ?, ?, ?, ?, ?)");
            ps.setString(1, patientId);
            ps.setString(2, masked);
            ps.setString(3, cardHolderName);
            ps.setString(4, expiryDate);
            ps.setNull(5, java.sql.Types.VARCHAR); // Do NOT store CVV
            ps.setBigDecimal(6, new java.math.BigDecimal(amount));
            int i = ps.executeUpdate();

            if (i > 0) {
                message = "Payment recorded (demo). For production, integrate a payment gateway.";
            } else {
                message = "Error occurred while recording the payment.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "Payment error.";
        } finally {
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Make a Payment</title>
    <link rel="stylesheet" type="text/css" href="css/payment.css">
</head>
<body>

<header>
    <h1>Payment</h1>
</header>

<div class="container">
    <div class="payment-form">
        <h2>Enter Your Payment Details</h2>
        <form method="post" action="payment.jsp">
            <div class="form-group">
                <label for="cardNumber">Card Number:</label>
                <input type="text" id="cardNumber" name="cardNumber" required>
            </div>
            <div class="form-group">
                <label for="cardHolderName">Card Holder Name:</label>
                <input type="text" id="cardHolderName" name="cardHolderName" required>
            </div>
            <div class="form-group">
                <label for="expiryDate">Expiry Date:</label>
                <input type="month" id="expiryDate" name="expiryDate" required>
            </div>
            <div class="form-group">
                <label for="cvv">CVV:</label>
                <input type="text" id="cvv" name="cvv" required>
            </div>
            <div class="form-group">
                <label for="amount">Amount:</label>
                <input type="text" id="amount" name="amount" value="<%= request.getParameter("amount") %>" required>
            </div>
            <div class="form-group">
                <button type="submit" name="submitPayment">Submit Payment</button>
            </div>
        </form>
        <p><%= message %></p>
    </div>
</div>

</body>
</html>
