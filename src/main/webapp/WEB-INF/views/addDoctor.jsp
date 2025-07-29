<%-- src/main/webapp/WEB-INF/jsp/addDoctor.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Add New Doctor - Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="/style.css"> <%-- Link to your custom CSS --%>
</head>
<body>
    <jsp:include page="common/header.jsp" />

    <div class="container mt-5">
        <div class="dashboard-header">
            <h2 class="text-primary">Add New Doctor</h2>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">${error}</div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success" role="alert">${successMessage}</div>
        </c:if>

        <form action="/admin/addDoctor" method="post"> <%-- IMPORTANT: enctype="multipart/form-data" IS REMOVED --%>
            <div class="mb-3">
                <label for="name" class="form-label">Doctor Name</label>
                <input type="text" class="form-control" id="name" name="name" required>
            </div>
            <div class="mb-3">
                <label for="specialization" class="form-label">Specialization</label>
                <input type="text" class="form-control" id="specialization" name="specialization" required>
            </div>
            <div class="mb-3">
                <label for="experience" class="form-label">Experience (Years)</label>
                <input type="number" class="form-control" id="experience" name="experience" min="0" required>
            </div>

            <%-- --- MANUAL PHOTO URL FIELD --- --%>
            <div class="mb-3">
                <label for="photoUrl" class="form-label">Doctor Photo URL</label>
                <input type="text" class="form-control" id="photoUrl" name="photoUrl" placeholder="/images/doctor_default.jpg" required>
                <small class="form-text text-muted">e.g., `/images/doctor_default.jpg`. Ensure this image is accessible.</small>
            </div>
            <%-- --- END MANUAL PHOTO URL FIELD --- --%>

            <%-- --- NEW USER ACCOUNT FIELDS FOR DOCTOR --- --%>
            <hr>
            <h5>Doctor's Login Credentials (New User Account)</h5>
            <div class="mb-3">
                <label for="userEmail" class="form-label">Doctor's Email (Login ID)</label>
                <input type="email" class="form-control" id="userEmail" name="userEmail" required>
                <small class="form-text text-muted">This will be the doctor's login email.</small>
            </div>
            <div class="mb-3">
                <label for="userPassword" class="form-label">Doctor's Password</label>
                <input type="password" class="form-control" id="userPassword" name="userPassword" required>
            </div>
            <%-- --- END NEW USER ACCOUNT FIELDS --- --%>

            <button type="submit" class="btn btn-primary">Add Doctor</button>
            <a href="/admin/dashboard" class="btn btn-secondary ms-2">Cancel</a>
        </form>
    </div>

    <footer class="footer">
        <div class="container">
            <p>&copy; 2025 Orgoz Doctor Clinic. All rights reserved.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>