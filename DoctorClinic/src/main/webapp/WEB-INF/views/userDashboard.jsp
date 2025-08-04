<%-- src/main/webapp/WEB-INF/jsp/userDashboard.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>User Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"> <%-- Added Font Awesome --%>
    <link rel="stylesheet" href="/style.css">
    <style>
        .card-img-top {
            height: 150px;
            object-fit: cover;
        }
    </style>
</head>
<body>
    <jsp:include page="common/header.jsp" />

    <div class="container py-5">
        <div class="dashboard-header">
            <h2 class="text-success"><i class="fas fa-chart-line"></i> User Dashboard</h2> <%-- Added icon --%>
        </div>

        <p class="mb-4 lead">Welcome, ${loggedInUser.name}!</p>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="card shadow-sm mb-5">
            <div class="card-header bg-success text-white">
                <h3 class="my-0"><i class="fas fa-search"></i> Find a Doctor</h3>
            </div>
            <div class="card-body">
                <form action="/userDashboard" method="get" class="row g-3 align-items-end">
                    <div class="col-md-5">
                        <label for="searchName" class="form-label visually-hidden">Doctor Name</label>
                        <input type="text" class="form-control" id="searchName" name="searchName"
                               placeholder="Search by Doctor Name" value="${searchName}">
                    </div>
                    <div class="col-md-5">
                        <label for="searchSpecialization" class="form-label visually-hidden">Specialization</label>
                        <input type="text" class="form-control" id="searchSpecialization" name="searchSpecialization"
                               placeholder="Search by Specialization" value="${searchSpecialization}">
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary w-100"><i class="fas fa-search"></i> Search</button>
                    </div>
                </form>
                <div class="col-12 mt-2">
                    <a href="/userDashboard" class="btn btn-outline-secondary btn-sm"><i class="fas fa-sync-alt"></i> Clear Search</a>
                </div>
            </div>
        </div>

        <h3 class="text-success mb-3">Available Doctors</h3>
        <div class="row">
            <c:if test="${empty doctors}">
                <div class="col-12">
                    <div class="alert alert-info" role="alert">
                        No doctors found matching your criteria.
                    </div>
                </div>
            </c:if>
            <c:forEach var="doc" items="${doctors}">
                <div class="col-md-4 mb-3">
                    <div class="card h-100">
                        <img src="${doc.photoUrl}" class="card-img-top" alt="Doctor Photo">
                        <div class="card-body">
                            <h5 class="card-title">${doc.name}</h5>
                            <p class="card-text">Specialization: ${doc.specialization}</p>
                            <p>Experience: ${doc.experience} years</p>
                            <a href="/appointments/book?doctorId=${doc.id}" class="btn btn-primary btn-sm"><i class="fas fa-calendar-plus"></i> Book Appointment</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <hr class="my-4">

        <h3 class="text-primary mb-3"><i class="fas fa-calendar-alt"></i> My Appointments</h3>
        <c:if test="${empty appointments}">
            <div class="alert alert-info" role="alert">
                You have no appointments scheduled yet.
            </div>
        </c:if>
        <c:if test="${not empty appointments}">
            <table class="table table-striped table-bordered">
                <thead>
                <tr>
                    <th>Doctor</th>
                    <th>Date</th>
                    <th>Time</th>
                    <th>Actions</th> <%-- NEW: Actions column for the delete button --%>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="appointment" items="${appointments}">
                    <tr>
                        <td>${appointment.doctor.name}</td>
                        <td>${appointment.date}</td>
                        <td>${appointment.time}</td>
                        <td>
                            <%-- Form for the Delete Action --%>
                            <form action="/appointments/delete" method="post" onsubmit="return confirm('Are you sure you want to cancel this appointment?');">
                                <input type="hidden" name="appointmentId" value="${appointment.id}">
                                <button type="submit" class="btn btn-danger btn-sm"><i class="fas fa-times-circle"></i> Cancel</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>

    <footer class="footer">
        <div class="container">
            <p>&copy; 2025 Orgos Doctor Clinic. All rights reserved.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>