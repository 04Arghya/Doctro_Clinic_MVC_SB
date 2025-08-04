<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Manage Doctors - Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="/style.css">
</head>
<body>
    <jsp:include page="common/header.jsp" />

    <div class="container mt-5">
        <div class="dashboard-header">
            <h2 class="text-primary">Manage Doctors</h2>
            <a href="/admin/addDoctor" class="btn btn-success">Add New Doctor</a>
        </div>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success" role="alert">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger" role="alert">${errorMessage}</div>
        </c:if>

        <table class="table table-striped mt-4">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Specialization</th>
                    <th>Experience</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="doctor" items="${doctors}">
                    <tr>
                        <td>${doctor.id}</td>
                        <td>${doctor.name}</td>
                        <td>${doctor.specialization}</td>
                        <td>${doctor.experience} years</td>
                        <td>
                            <%-- Form for the Delete Action --%>
                            <form action="/admin/deleteDoctor" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this doctor?');">
                                <input type="hidden" name="id" value="${doctor.id}">
                                <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty doctors}">
                    <tr>
                        <td colspan="5" class="text-center">No doctors found.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <footer class="footer">
        <div class="container">
            <p>&copy; 2025 Orgoz Doctor Clinic. All rights reserved.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>