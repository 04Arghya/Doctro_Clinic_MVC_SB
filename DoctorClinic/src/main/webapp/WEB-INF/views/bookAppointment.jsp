<%-- src/main/webapp/WEB-INF/jsp/bookAppointment.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Book Appointment - Orgos Clinic</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="/style.css"> <%-- Link to your custom CSS --%>
</head>
<body>
    <jsp:include page="common/header.jsp" />

    <div class="container mt-5">
        <div class="dashboard-header">
            <h2 class="text-primary">Book Appointment with Dr. ${doctor.name}</h2>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">${error}</div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success" role="alert">${successMessage}</div>
        </c:if>

        <form action="/appointments/book" method="post"> <%-- UPDATED FORM ACTION --%>
            <input type="hidden" name="doctorId" value="${doctor.id}">

            <div class="mb-3">
                <label for="date" class="form-label">Select Date:</label>
                <input type="date" class="form-control" id="date" name="date" required min="<%=java.time.LocalDate.now()%>">
            </div>

            <div class="mb-3">
                <label for="time" class="form-label">Select Time:</label>
                <input type="time" class="form-control" id="time" name="time" required>
            </div>

            <button type="submit" class="btn btn-primary">Confirm Booking</button>
            <a href="/userDashboard" class="btn btn-secondary ms-2">Cancel</a>
        </form>
    </div>

    <footer class="footer">
        <div class="container">
            <p>&copy; 2025 Orgos Doctor Clinic. All rights reserved.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>