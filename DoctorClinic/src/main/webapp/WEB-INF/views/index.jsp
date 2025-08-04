<%-- src/main/webapp/WEB-INF/jsp/index.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>Orgos Doctor Clinic - Home</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/style.css">
    <style>
        :root {
            --primary-color: #198754; /* Bootstrap's success green */
            --secondary-color: #0d6efd; /* Bootstrap's primary blue */
            --background-light: #f8f9fa;
            --text-dark: #212529;
            --text-light: #fff;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol";
            color: var(--text-dark);
            background-color: var(--background-light);
        }

        .navbar {
            box-shadow: 0 2px 4px rgba(0,0,0,.05);
        }

        .hero-section {
            background: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)), url('/images/hero-bg.jpg') no-repeat center center;
            background-size: cover;
            color: var(--text-light);
            padding: 10rem 0;
            text-align: center;
        }
        .hero-section h1 {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }
        .hero-section p {
            font-size: 1.25rem;
            margin-bottom: 2rem;
        }

        .section-content {
            padding: 4rem 0;
            border-bottom: 1px solid #e9ecef;
        }
        .section-heading {
            text-align: center;
            margin-bottom: 3rem;
            font-size: 2.5rem;
            font-weight: 600;
            color: var(--primary-color);
            position: relative;
        }
        .section-heading::after {
            content: '';
            position: absolute;
            left: 50%;
            bottom: -10px;
            transform: translateX(-50%);
            width: 80px;
            height: 3px;
            background-color: var(--secondary-color);
        }

        .img-fluid {
            border-radius: .5rem;
            box-shadow: 0 4px 12px rgba(0,0,0,.1);
        }

        .card-service {
            border: none;
            border-radius: 1rem;
            text-align: center;
            padding: 2rem 1rem;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            background-color: var(--text-light);
            box-shadow: 0 4px 12px rgba(0,0,0,.05);
        }
        .card-service:hover {
            transform: translateY(-10px);
            box-shadow: 0 8px 24px rgba(0,0,0,.1);
        }
        .card-service .icon {
            font-size: 3rem;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }
        .card-service h5 {
            font-weight: 600;
        }

        .footer {
            background-color: var(--text-dark);
            color: var(--background-light);
            padding: 2rem 0;
            text-align: center;
            margin-top: 2rem;
        }
        .footer a {
            color: var(--primary-color);
            text-decoration: none;
        }
        .footer a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <%-- Include Header --%>
    <jsp:include page="common/header.jsp" />

    <section class="hero-section">
        <div class="container">
            <c:choose>
                <c:when test="${sessionScope.loggedInUser != null}">
                    <h1>Welcome, ${sessionScope.loggedInUser.name}!</h1>
                    <p class="lead">We're glad to see you back. Explore doctors or manage your appointments.</p>
                    <div class="d-grid gap-2 d-sm-flex justify-content-sm-center">
                        <c:if test="${sessionScope.loggedInUser.role eq 'PATIENT'}">
                            <a href="/userDashboard" class="btn btn-success btn-lg px-4 me-sm-3">View Dashboard</a>
                            <a href="/find-doctors" class="btn btn-outline-light btn-lg px-4">Book an Appointment</a>
                        </c:if>
                        <c:if test="${sessionScope.loggedInUser.role eq 'DOCTOR'}">
                            <a href="/doctorDashboard" class="btn btn-success btn-lg px-4 me-sm-3">View Dashboard</a>
                            <a href="/appointments" class="btn btn-outline-light btn-lg px-4">View Schedule</a>
                        </c:if>
                        <c:if test="${sessionScope.loggedInUser.role eq 'ADMIN'}">
                            <a href="/admin/dashboard" class="btn btn-success btn-lg px-4 me-sm-3">View Dashboard</a>
                            <a href="/admin/users" class="btn btn-outline-light btn-lg px-4">Manage Users</a>
                        </c:if>
                    </div>
                </c:when>
                <c:otherwise>
                    <h1>Your Health, Our Priority</h1>
                    <p class="lead">Providing compassionate and expert care for a healthier tomorrow.</p>
                    <div class="d-grid gap-2 d-sm-flex justify-content-sm-center">
                        <a href="/signup" class="btn btn-success btn-lg px-4 me-sm-3">Get Started Today</a>
                        <a href="/login" class="btn btn-outline-light btn-lg px-4">Existing User? Login</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <div class="container">
        <section id="services" class="section-content">
            <h2 class="section-heading">Our Services</h2>
            <div class="row g-4">
                <div class="col-lg-4 col-md-6">
                    <div class="card card-service">
                        <div class="icon"><i class="fas fa-stethoscope"></i></div>
                        <h5>General Checkups</h5>
                        <p class="text-muted">Comprehensive health assessments and preventative care.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="card card-service">
                        <div class="icon"><i class="fas fa-user-md"></i></div>
                        <h5>Specialized Treatments</h5>
                        <p class="text-muted">Access to specialists across various medical fields.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="card card-service">
                        <div class="icon"><i class="fas fa-heartbeat"></i></div>
                        <h5>Cardiology</h5>
                        <p class="text-muted">Expert care for heart health and cardiovascular conditions.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="card card-service">
                        <div class="icon"><i class="fas fa-dna"></i></div>
                        <h5>Pathology Lab</h5>
                        <p class="text-muted">On-site lab services for quick and accurate diagnostics.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="card card-service">
                        <div class="icon"><i class="fas fa-child"></i></div>
                        <h5>Pediatrics</h5>
                        <p class="text-muted">Dedicated care for infants, children, and adolescents.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="card card-service">
                        <div class="icon"><i class="fas fa-tooth"></i></div>
                        <h5>Dental Care</h5>
                        <p class="text-muted">Routine cleanings, checkups, and advanced dental procedures.</p>
                    </div>
                </div>
            </div>
        </section>

        <section id="description" class="section-content">
            <h2 class="section-heading">Welcome to Orgos Clinic</h2>
            <div class="row align-items-center">
                <div class="col-md-6">
                    <img src="/images/unnamed.jpg" alt="Clinic Interior" class="img-fluid mb-3">
                </div>
                <div class="col-md-6">
                    <p>At Orgos Clinic, we are dedicated to providing comprehensive and compassionate healthcare services. Our team of experienced doctors and staff are committed to your well-being, offering personalized care tailored to your needs.</p>
                    <p>From routine check-ups to specialized treatments, we utilize state-of-the-art technology and a patient-centric approach to ensure the best possible outcomes. Trust us to be your partner in health.</p>
                </div>
            </div>
        </section>

        <section id="about" class="section-content">
            <h2 class="section-heading">About Us</h2>
            <div class="row align-items-center flex-row-reverse">
                <div class="col-md-6">
                    <img src="/images/AboutUs.png" alt="Our Team" class="img-fluid mb-3">
                </div>
                <div class="col-md-6">
                    <p>Orgos Clinic was founded with a vision to make quality healthcare accessible and affordable. We believe in a holistic approach to health, focusing not just on treating illnesses but also on preventative care and promoting overall wellness.</p>
                    <p>Our clinic boasts a diverse team of specialists across various disciplines, all united by a common goal: to provide exceptional medical care with integrity and empathy. We are constantly striving to update our knowledge and technology to serve you better.</p>
                </div>
            </div>
        </section>
        
        <%-- New Dynamic Section for "Appointment" --%>
        <c:if test="${sessionScope.loggedInUser.role eq 'PATIENT'}">
             <section id="appointment-cta" class="section-content text-center bg-light">
                 <h2 class="section-heading">Ready to Book an Appointment?</h2>
                 <p class="lead mb-4">You can easily book a new appointment with our doctors through our streamlined system.</p>
                 <a href="/find-doctors" class="btn btn-primary btn-lg"><i class="fas fa-calendar-check me-2"></i>Book Now</a>
             </section>
        </c:if>

        <section id="contact" class="section-content">
            <h2 class="section-heading">Contact Us</h2>
            <div class="row">
                <div class="col-md-6">
                    <p>Have questions or need to schedule an appointment? Feel free to reach out to us!</p>
                    <ul class="list-unstyled">
                        <li><i class="fas fa-map-marker-alt me-2 text-primary"></i><strong>Address:</strong> Serampore , Hooghly</li>
                        <li><i class="fas fa-phone-alt me-2 text-primary"></i><strong>Phone:</strong> +91 98765 43210</li>
                        <li><i class="fas fa-envelope me-2 text-primary"></i><strong>Email:</strong> info@orgozclinic.com</li>
                        <li><i class="fas fa-clock me-2 text-primary"></i><strong>Hours:</strong> Mon-Fri: 9 AM - 6 PM</li>
                    </ul>
                </div>
                <div class="col-md-6">
                    <form>
                        <div class="mb-3">
                            <label for="contactName" class="form-label">Your Name</label>
                            <input type="text" class="form-control" id="contactName" required>
                        </div>
                        <div class="mb-3">
                            <label for="contactEmail" class="form-label">Your Email</label>
                            <input type="email" class="form-control" id="contactEmail" required>
                        </div>
                        <div class="mb-3">
                            <label for="contactMessage" class="form-label">Message</label>
                            <textarea class="form-control" id="contactMessage" rows="4" required></textarea>
                        </div>
                        <button type="submit" class="btn btn-success">Send Message</button>
                    </form>
                </div>
            </div>
        </section>
    </div>

    <%-- Footer --%>
    <footer class="footer">
        <div class="container">
            <div class="row">
                <div class="col-md-6 text-md-start mb-2 mb-md-0">
                     <p class="mb-0">&copy; <fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy" /> Orgos Doctor Clinic. All rights reserved.</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <a href="#" class="me-3">Privacy Policy</a>
                    <a href="#">Terms of Service</a>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>