<%-- src/main/webapp/WEB-INF/jsp/signup.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Sign Up - MedCare Clinic</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="/style.css"> <%-- Link to your custom CSS --%>
</head>
<body>
<jsp:include page="common/header.jsp" />

<div class="container col-md-6 mt-5">
    <div class="dashboard-header">
        <h2 class="text-success">Sign Up for Orgos Clinic</h2>
    </div>
    <c:if test="${not empty error}">
        <div class="alert alert-danger" role="alert">${error}</div>
    </c:if>
    <form method="post" action="/signup">
        <div class="mb-3">
            <label for="name" class="form-label">Full Name</label>
            <input type="text" name="name" id="name" class="form-control" required>
        </div>
        <div class="mb-3">
            <label for="email" class="form-label">Email address</label>
            <input type="email" name="email" id="email" class="form-control" required>
        </div>
        <div class="mb-3">
            <label for="password" class="form-label">Password</label>
            <input type="password" name="password" id="password" class="form-control" required>
        </div>
        <div class="d-grid gap-2">
            <button type="submit" class="btn btn-success">Register</button>
        </div>
    </form>
    <p class="mt-3 text-center">Already have an account? <a href="/login">Login here</a></p>
</div>

<footer class="footer">
    <div class="container">
        <p>&copy; 2025 Orgoz Doctos Clinic. All rights reserved.</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>