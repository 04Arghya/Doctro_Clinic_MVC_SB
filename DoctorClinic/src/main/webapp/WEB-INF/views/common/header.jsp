<%-- src/main/webapp/WEB-INF/jsp/common/header.jsp --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="/">Orgos Clinic</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" aria-current="page" href="/">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#about">About Us</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#contact">Contact</a>
                </li>
            </ul>
            <div class="d-flex">
                <c:choose>
                    <c:when test="${sessionScope.loggedInUser == null}">
                        <a href="/login" class="btn btn-outline-light me-2">Login</a>
                        <a href="/signup" class="btn btn-outline-light">Signup</a>
                    </c:when>
                    <c:otherwise>
                        <span class="navbar-text text-white me-3">
                            Welcome, ${sessionScope.loggedInUser.name}!
                        </span>
                        <a href="/logout" class="btn btn-outline-light">Logout</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>