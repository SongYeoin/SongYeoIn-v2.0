<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Schedule</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css' rel='stylesheet' />
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            padding-top: 70px; /* Space for the fixed header */
            padding-left: 250px; /* Space for the fixed sidebar */
            padding-right: 20px; /* Padding on the right side */
            padding-bottom: 50px; /* Space for the fixed footer */
        }

        header {
            background-color: black;
            color: white;
            padding: 20px;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
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
            left: 250px; /* Position to the right of the sidebar */
            width: calc(100% - 250px); /* Full width minus sidebar width */
            z-index: 1000;
        }

        .container {
            max-width: 600px;
            margin: 0 auto;
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        h1 {
            margin-bottom: 20px;
            font-size: 24px;
        }

        form label {
            display: block;
            margin: 10px 0 5px;
        }

        form input[type="text"],
        form input[type="date"],
        form select {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 4px;
            border: 1px solid #ddd;
            font-size: 16px;
        }

        form input[type="submit"] {
            width: 100%;
            padding: 10px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
        }

        form input[type="submit"]:hover {
            background-color: #0056b3;
        }

        .back-link {
            display: block;
            margin-top: 20px;
            font-size: 16px;
            text-decoration: none;
            color: #007bff;
        }

        .back-link:hover {
            text-decoration: underline;
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
    <div class="container">
        <h1>Create New Schedule</h1>
        <form action="${pageContext.request.contextPath}/journal/scheduleCreate" method="post">
            <label for="scheduleTitle">Title:</label>
            <input type="text" name="scheduleTitle" id="scheduleTitle" required />

            <label for="scheduleDate">Date:</label>
            <input type="date" name="scheduleDate" id="scheduleDate" required />

            <label for="scheduleDescription">Description:</label>
            <input type="text" name="scheduleDescription" id="scheduleDescription" />

            <label for="scheduleInstructor">Instructor:</label>
            <input type="text" name="scheduleInstructor" id="scheduleInstructor" />

            <input type="submit" value="Create Schedule" />
        </form>
        <a href="${pageContext.request.contextPath}/journal/scheduleList" class="back-link">Back to List</a>
    </div>

    <!-- Footer -->
    <footer>
        <%@ include file="../common/footer.jsp"%>
    </footer>

</body>
</html>
