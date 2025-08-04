<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
    <title>Orgo's Clinic - Make Payment</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="/style.css"> <%-- Link to your custom CSS --%>
    <style>
        body {
            background-color: #f8f9fa;
        }
        .payment-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 30px;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            text-align: center; /* Center content */
        }
        .alert-message {
            margin-top: 20px;
        }
        .btn-razorpay {
            background-color: #007bff; /* Razorpay blue */
            border-color: #007bff;
            color: white;
            padding: 12px 25px;
            font-size: 1.1rem;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }
        .btn-razorpay:hover {
            background-color: #0056b3;
            border-color: #0056b3;
        }
    </style>
</head>
<body>
    <%-- Include Header --%>
    <jsp:include page="common/header.jsp" />

    <div class="container payment-container">
        <h2 class="text-center mb-4">Confirm Your Payment</h2>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-message" role="alert">
                ${errorMessage}
            </div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-message" role="alert">
                ${successMessage}
            </div>
        </c:if>

        <c:choose>
            <c:when test="${not empty appointmentId && not empty orderId && not empty amount && not empty razorpayKeyId}">
                <div class="mb-4">
                    <p class="h5">Appointment Summary:</p>
                    <p><strong>Appointment ID:</strong> ${appointmentId}</p>
                    <p><strong>Service:</strong> <c:out value="${appointmentDetails.serviceName}" default="General Consultation"/></p>
                    <p><strong>Date:</strong> <c:out value="${appointmentDetails.appointmentDate}" default="N/A"/></p>
                    <p><strong>Time:</strong> <c:out value="${appointmentDetails.appointmentTime}" default="N/A"/></p>
                    <p class="h4 mt-3">Amount Due: ₹<c:out value="${amount / 100.0}" default="0.00"/></p> <%-- Amount is in paisa from backend, convert to Rupee --%>
                </div>

                <button id="rzp-button1" class="btn btn-razorpay">Pay with Razorpay</button>

                <p class="text-muted text-center mt-3">
                    (Your payment will be processed securely by Razorpay.)
                </p>

                <%-- Razorpay Checkout Script --%>
                <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
                <script>
                    var options = {
                        "key": "${razorpayKeyId}", // Your Razorpay Key ID from backend
                        "amount": "${amount}", // Amount in paisa
                        "currency": "INR",
                        "name": "Orgo's Clinic",
                        "description": "Appointment Payment for ID: ${appointmentId}",
                        "order_id": "${orderId}", // Order ID from backend
                        "handler": function (response){
                            // This function is called after successful payment on Razorpay's side
                            // Send the response to your backend for verification
                            var form = document.createElement('form');
                            form.method = 'POST';
                            form.action = '/api/payments/verify-payment'; // Backend endpoint for verification

                            var inputRazorpayPaymentId = document.createElement('input');
                            inputRazorpayPaymentId.type = 'hidden';
                            inputRazorpayPaymentId.name = 'razorpay_payment_id';
                            inputRazorpayPaymentId.value = response.razorpay_payment_id;
                            form.appendChild(inputRazorpayPaymentId);

                            var inputRazorpayOrderId = document.createElement('input');
                            inputRazorpayOrderId.type = 'hidden';
                            inputRazorpayOrderId.name = 'razorpay_order_id';
                            inputRazorpayOrderId.value = response.razorpay_order_id;
                            form.appendChild(inputRazorpayOrderId);

                            var inputRazorpaySignature = document.createElement('input');
                            inputRazorpaySignature.type = 'hidden';
                            inputRazorpaySignature.name = 'razorpay_signature';
                            inputRazorpaySignature.value = response.razorpay_signature;
                            form.appendChild(inputRazorpaySignature);

                            var inputAppointmentId = document.createElement('input');
                            inputAppointmentId.type = 'hidden';
                            inputAppointmentId.name = 'appointmentId';
                            inputAppointmentId.value = "${appointmentId}";
                            form.appendChild(inputAppointmentId);

                            document.body.appendChild(form);
                            form.submit();
                        },
                        "prefill": {
                            "name": "<c:out value='${sessionScope.loggedInUser.name}' default='Patient Name'/>",
                            "email": "<c:out value='${sessionScope.loggedInUser.email}' default='patient@example.com'/>",
                            "contact": "<c:out value='${sessionScope.loggedInUser.phone}' default='9999999999'/>" // Assuming user has a phone field
                        },
                        "theme": {
                            "color": "#68B043" // Orgo's Clinic green
                        }
                    };
                    var rzp1 = new Razorpay(options);

                    document.getElementById('rzp-button1').onclick = function(e){
                        rzp1.open();
                        e.preventDefault();
                    }
                </script>
            </c:when>
            <c:otherwise>
                <div class="alert alert-warning" role="alert">
                    Payment details are missing. Please ensure you have a valid appointment.
                </div>
                <div class="text-center">
                    <a href="/userDashboard" class="btn btn-primary">Go to Dashboard</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
