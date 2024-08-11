<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Schedule</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css' rel='stylesheet' />
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            padding-top: 70px; /* Space for the fixed header */
            padding-left: 250px; /* Space for the fixed sidebar */
            padding-right: 20px; /* Space on the right side */
        }

        header {
            background-color: black;
            color: white;
            padding: 20px;
            position: fixed;
            top: 0;
            left: 0;
            width: calc(100% - 250px); /* Full width minus sidebar width */
            z-index: 1000;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .sidebar {
            width: 250px;
            background-color: #F2F2F2;
            color: #333333;
            height: calc(100vh - 70px); /* Full height minus header height */
            position: fixed;
            top: 70px; /* Below the header */
            left: 0;
            overflow-y: auto;
            border-right: 1px solid #ddd;
            padding-top: 20px;
        }

        footer {
            background-color: #BBB2FF;
            color: white;
            padding: 20px;
            text-align: center;
            position: fixed;
            bottom: 0;
            left: 250px; /* Align with the sidebar */
            width: calc(100% - 250px); /* Full width minus sidebar width */
            z-index: 1000;
        }

        .main-content {
            margin-left: 250px; /* Space for the sidebar */
            margin-bottom: 50px; /* Space for the footer */
            padding: 20px;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin-top: 20px; /* Margin to create space from the header */
        }

        h1 {
            margin-bottom: 20px;
            font-size: 28px;
            font-weight: 600;
        }

        p {
            font-size: 16px;
            margin-bottom: 15px;
        }

        a {
            color: #007bff;
            text-decoration: none;
            font-size: 16px;
        }

        a:hover {
            text-decoration: underline;
        }

        button {
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            color: white;
            cursor: pointer;
            font-size: 16px;
            margin-right: 10px;
        }

        button[type="submit"] {
            background-color: #dc3545;
        }

        button[type="submit"]:hover {
            background-color: #c82333;
        }

        .btn-container {
            margin-top: 20px;
        }

        .btn-container a {
            margin-right: 10px;
        }
    </style>
</head>
<body>

    <!-- Header -->
    <header>
        <%@ include file="../common/header.jsp"%>
    </header>

    <!-- Sidebar -->
    <div class="sidebar">
        <%@ include file="../member/aside.jsp"%>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container">
            <h1>${scheduleDetail.scheduleTitle}</h1>
            <!-- Schedule details -->
            <p>Date: ${scheduleDetail.scheduleDate}</p>
            <p>Description: ${scheduleDetail.scheduleDescription}</p>
            <p>Instructor: ${scheduleDetail.scheduleInstructor}</p>
            
            <!-- Button container for alignment -->
            <div class="btn-container">
                <!-- Update schedule -->
                <a href="${pageContext.request.contextPath}/journal/scheduleUpdate?scheduleNo=${scheduleDetail.scheduleNo}" class="btn btn-primary">Edit</a>
                
                <!-- Delete schedule -->
                <form action="${pageContext.request.contextPath}/journal/scheduleDelete" method="post" style="display: inline;">
                    <input type="hidden" name="scheduleNo" value="${scheduleDetail.scheduleNo}" />
                    <button type="submit" onclick="return confirm('Are you sure you want to delete this schedule?');">Delete</button>
                </form>
            </div>
            
            <!-- Back to list -->
            <a href="${pageContext.request.contextPath}/journal/scheduleList" class="btn btn-link">Back to List</a>
        </div>
    </div>

    <!-- Footer -->
    <footer>
        <%@ include file="../common/footer.jsp"%>
    </footer>

</body>
</html>
