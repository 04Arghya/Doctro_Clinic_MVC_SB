<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="/style.css"> <%-- Link to your custom CSS --%>
    <style>
        body {
            background-color: #f8f9fa;
        }
        .dashboard-header {
            padding: 2rem 0;
            border-bottom: 1px solid #dee2e6;
            margin-bottom: 2rem;
        }
        .section-card {
            background-color: #fff;
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 2rem;
            margin-bottom: 2rem;
        }
        .section-card h3 {
            border-bottom: 2px solid #0dcaf0;
            padding-bottom: 0.5rem;
            margin-bottom: 1.5rem;
        }
        .table-striped > tbody > tr:nth-of-type(odd) {
            background-color: rgba(13, 202, 240, 0.05);
        }
        .footer {
            margin-top: auto; /* Push the footer to the bottom */
            padding: 1.5rem 0;
            background-color: #343a40;
            color: #fff;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">
    <jsp:include page="common/header.jsp" /> <%-- Include Header --%>

    <div class="container my-5">
        <header class="dashboard-header text-center">
            <h1 class="display-4 text-info">Doctor Dashboard</h1>
            <p class="lead">Welcome, Dr. ${doctorName}!</p>
        </header>

        <section class="section-card">
            <h3>Your Assigned Patients:</h3>
            <c:choose>
                <c:when test="${empty assignedPatients}">
                    <div class="alert alert-info" role="alert">
                        No patients currently assigned to you.
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="table table-hover">
                        <thead class="table-info">
                            <tr>
                                <th>Patient Name</th>
                                <th>Email</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="patient" items="${assignedPatients}">
                                <tr>
                                    <td>${patient.name}</td>
                                    <td>${patient.email}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </section>

        <section class="section-card">
            <h3>All Your Appointments:</h3>
            <c:choose>
                <c:when test="${empty appointments}">
                    <div class="alert alert-info" role="alert">
                        You have no appointments scheduled.
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="table table-hover">
                        <thead class="table-info">
                            <tr>
                                <th>Patient Name</th>
                                <th>Date</th>
                                <th>Time</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="appointment" items="${appointments}">
                                <tr>
                                    <td>${appointment.user.name}</td>
                                    <td>${appointment.date}</td>
                                    <td>${appointment.time}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </section>
    </div>

    <footer class="footer mt-auto py-3 text-center">
        <div class="container">
            <span>&copy; 2025 Orgos Doctor Clinic. All rights reserved.</span>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>