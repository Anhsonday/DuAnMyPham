

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="java.util.*, java.math.BigDecimal, model.entity.*, dao.impl.*" %>

<%-- Đã loại bỏ toàn bộ code Java khởi tạo DAO và truy vấn DB ở đây. Dữ liệu đã được truyền từ Servlet qua request attribute. --%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Cosmetic Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --primary-color: #4e73df;
            --secondary-color: #858796;
            --success-color: #1cc88a;
            --info-color: #36b9cc;
            --warning-color: #f6c23e;
            --danger-color: #e74a3b;
            --light-color: #f8f9fc;
            --dark-color: #5a5c69;
        }
        
        body {
            background-color: #f8f9fc;
            font-family: 'Nunito', 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            overflow-x: hidden;
        }
        
        .card {
            border: none;
            border-radius: 0.75rem;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            margin-bottom: 1.5rem;
            overflow: hidden;
            backdrop-filter: blur(10px);
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 0.5rem 2rem 0 rgba(58, 59, 69, 0.2);
        }
        
        .stat-card {
            color: white;
            border-left: 0.25rem solid rgba(255, 255, 255, 0.3);
            position: relative;
            z-index: 1;
            overflow: hidden;
        }
        
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.08);
            z-index: -1;
            transform: skewX(-15deg) translateX(-100%);
            transition: transform 0.5s ease;
        }
        
        .stat-card:hover::before {
            transform: skewX(-15deg) translateX(0);
        }
        
        .stat-card .card-body {
            padding: 1.5rem 1.5rem;
            position: relative;
        }
        
        .stat-card .icon {
            opacity: 0.3;
            position: absolute;
            right: 1.5rem;
            font-size: 2.5rem;
            transition: all 0.3s ease;
        }
        
        .stat-card:hover .icon {
            opacity: 0.5;
            transform: scale(1.1);
        }
        
        .stat-card.users {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }
        
        .stat-card.products {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
        }
        
        .stat-card.orders {
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
        }
        
        .stat-card.revenue {
            background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
        }
        
        .chart-card {
            height: 100%;
        }
        
        .chart-container {
            position: relative;
            height: 400px;
            width: 100%;
            padding: 10px;
        }
        
        .card-header {
            background-color: transparent;
            border-bottom: 1px solid rgba(0,0,0,.05);
            padding: 1rem 1.25rem;
            font-weight: 700;
            color: #4e73df;
        }
        
        .card-header h5 {
            margin-bottom: 0;
            font-size: 1.25rem;
            font-weight: 700;
        }
        
        main {
            padding: 1.5rem;
            transition: all 0.3s;
            background-color: #f8f9fc;
        }
        
        .dashboard-heading {
            font-weight: 700;
            margin-bottom: 1.5rem;
            color: #5a5c69;
            border-bottom: 1px solid #e3e6f0;
            padding-bottom: 0.5rem;
            position: relative;
        }
        
        .dashboard-heading::after {
            content: '';
            position: absolute;
            left: 0;
            bottom: -1px;
            width: 80px;
            height: 3px;
            background: linear-gradient(90deg, #4e73df, #36b9cc);
        }
        
        .stat-card .value {
            font-size: 1.75rem;
            font-weight: 700;
            margin-bottom: 0;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
        }
        
        .stat-card .title {
            font-size: 0.9rem;
            font-weight: 600;
            text-transform: uppercase;
            margin-bottom: 0.5rem;
            letter-spacing: 0.1em;
        }
        
        .stat-card .link {
            color: rgba(255, 255, 255, 0.8);
            font-size: 0.8rem;
            text-decoration: none;
            display: inline-block;
            margin-top: 0.5rem;
            transition: all 0.2s;
            position: relative;
            padding-right: 15px;
        }
        
        .stat-card .link:hover {
            color: white;
            transform: translateX(3px);
        }
        
        /* Animation classes */
        .animate-fade-in {
            animation: fadeIn 0.5s ease-in;
        }
        
        .animate-slide-up {
            animation: slideUp 0.5s ease-out forwards;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        @keyframes slideUp {
            from { transform: translateY(20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        
        /* Responsive adjustments */
        @media (max-width: 768px) {
            .stat-card .icon {
                display: none;
            }
        }
        
        /* Loading animation */
        .loading {
            position: relative;
        }
        
        .loading:after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255,255,255,0.8);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 10;
        }
        
        /* Table styles */
        .table {
            color: #5a5c69;
        }
        
        .table thead th {
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            font-size: 0.85rem;
            border-top: none;
        }
        
        .table-hover tbody tr:hover {
            background-color: rgba(78, 115, 223, 0.05);
        }
        
        .badge {
            font-weight: 600;
            padding: 0.35em 0.65em;
            font-size: 0.75em;
        }
        
        /* Button styles */
        .btn-primary {
            background-color: #4e73df;
            border-color: #4e73df;
        }
        
        .btn-primary:hover {
            background-color: #2e59d9;
            border-color: #2e59d9;
        }
        
        /* List group item */
        .list-group-item {
            border-color: rgba(0,0,0,.05);
            transition: all 0.2s;
        }
        
        .list-group-item:hover {
            background-color: rgba(78, 115, 223, 0.05);
        }
        
        /* Pill badges */
        .badge.rounded-pill {
            font-size: 0.7rem;
            font-weight: 600;
            padding: 0.35em 0.8em;
        }
        
        /* Product box in list */
        .product-box {
            width: 40px;
            height: 40px;
            background: #f1f3f9;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            transition: all 0.2s;
        }
        
        /* Progress bar */
        .progress {
            height: 0.5rem;
            background-color: #eaecf4;
            border-radius: 0.25rem;
            overflow: hidden;
        }
        
        .progress-bar {
            background-color: #4e73df;
        }
        
        /* Card hover effect */
        .card.lift {
            transition: transform 0.2s, box-shadow 0.2s;
        }
        
        .card.lift:hover {
            transform: translateY(-0.25rem);
            box-shadow: 0 0.5rem 2rem 0 rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Include Admin Sidebar -->
            <jsp:include page="admin/includes/sidebar.jsp">
                <jsp:param name="page" value="dashboard" />
            </jsp:include>

            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 animate-fade-in">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-4">
                    <h1 class="h2 dashboard-heading">Bảng điều khiển tổng quan</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <button type="button" class="btn btn-sm btn-outline-primary">
                                <i class="bi bi-download me-1"></i> Xuất
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-secondary">
                                <i class="bi bi-printer me-1"></i> In
                            </button>
                        </div>
                        <button type="button" class="btn btn-sm btn-outline-secondary dropdown-toggle d-flex align-items-center gap-1">
                            <i class="bi bi-calendar3"></i>
                            Tuần này
                        </button>
                    </div>
                </div>
                
                <!-- Statistics Cards -->
                <div class="row animate-slide-up">
                    <div class="col-xl-3 col-md-6 mb-4" style="animation-delay: 0.1s;">
                        <div class="card stat-card users h-100">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col">
                                        <div class="title">Tổng người dùng</div>
                                        <div class="value">${totalUsers}</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="bi bi-people icon"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-xl-3 col-md-6 mb-4" style="animation-delay: 0.2s;">
                        <div class="card stat-card products h-100">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col">
                                        <div class="title">Tổng sản phẩm</div>
                                        <div class="value">${totalProducts}</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="bi bi-box icon"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-xl-3 col-md-6 mb-4" style="animation-delay: 0.3s;">
                        <div class="card stat-card orders h-100">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col">
                                        <div class="title">Tổng đơn hàng</div>
                                        <div class="value">${totalOrders}</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="bi bi-cart icon"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-xl-3 col-md-6 mb-4" style="animation-delay: 0.4s;">
                        <div class="card stat-card revenue h-100">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col">
                                        <div class="title">Tổng doanh thu</div>
                                        <div class="value">${revenueTotalFormatted} đ</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="bi bi-coin icon"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Charts -->
                <div class="row animate-slide-up" style="animation-delay: 0.5s;">
                    <div class="col-lg-8 mb-4">
                        <div class="card chart-card shadow">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5><i class="bi bi-graph-up me-2"></i>Biểu đồ doanh thu</h5>
                                <div class="dropdown">
                                    <button class="btn btn-sm btn-link text-muted" type="button" id="revenueDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="bi bi-three-dots-vertical"></i>
                                    </button>
                                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="revenueDropdown">
                                        <li><a class="dropdown-item" href="#">7 ngày qua</a></li>
                                        <li><a class="dropdown-item" href="#">Tháng này</a></li>
                                        <li><a class="dropdown-item" href="#">Năm nay</a></li>
                                    </ul>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="chart-container">
                                    <canvas id="revenueChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4 mb-4">
                        <div class="card chart-card shadow">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5><i class="bi bi-pie-chart me-2"></i>Trạng thái đơn hàng</h5>
                                <div class="dropdown">
                                    <button class="btn btn-sm btn-link text-muted" type="button" id="ordersDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="bi bi-three-dots-vertical"></i>
                                    </button>
                                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="ordersDropdown">
                                        <li><a class="dropdown-item" href="#">7 ngày qua</a></li>
                                        <li><a class="dropdown-item" href="#">Tháng này</a></li>
                                        <li><a class="dropdown-item" href="#">Năm nay</a></li>
                                    </ul>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="chart-container">
                                    <canvas id="ordersChart"></canvas>
                                </div>
                                <div class="mt-4 text-center small">
                                    <span class="me-2"><i class="bi bi-circle-fill" style="color:#f6c23e"></i> Đang chờ</span>
                                    <span class="me-2"><i class="bi bi-circle-fill" style="color:#36b9cc"></i> Đang giao</span>
                                    <span class="me-2"><i class="bi bi-circle-fill" style="color:#1cc88a"></i> Hoàn thành</span>
                                    <span class="me-2"><i class="bi bi-circle-fill" style="color:#7c43bd"></i> Hoàn trả</span>
                                    <span class="me-2"><i class="bi bi-circle-fill" style="color:#e74a3b"></i> Đã hủy</span>
                                    <span><i class="bi bi-circle-fill" style="color:#858796"></i> Đã hoàn tiền</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                
            </main>
        </div>
    </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Safe chart initialization with error handling
        document.addEventListener('DOMContentLoaded', function() {
            // Gọi API lấy dữ liệu thật trước khi khởi tạo biểu đồ
            fetch(`${pageContext.request.contextPath}/api/revenue-data?range=this-week`)
                .then(response => response.json())
                .then(data => {
                    initializeCharts(data);
                })
                .catch(error => {
                    // Nếu lỗi, fallback về staticData tiếng Việt
                    const staticData = getStaticDataForRange('this-week');
                    initializeCharts(staticData);
                });
            
            // Add animation to cards
            document.querySelectorAll('.animate-slide-up').forEach(function(element) {
                element.classList.add('animate__animated', 'animate__fadeInUp');
            });
            
            // Set up button functionality
            setupButtonHandlers();
        });
        
        // Handle button actions
        function setupButtonHandlers() {
            // Export button functionality
            document.querySelector('.btn-outline-primary').addEventListener('click', function() {
                exportDashboardData();
            });
            
            // Print button functionality
            document.querySelector('.btn-outline-secondary:not(.dropdown-toggle)').addEventListener('click', function() {
                window.print();
            });
            
            // Date range dropdown
            const dateRangeBtn = document.querySelector('.dropdown-toggle');
            
            // Create dropdown menu
            const dropdownMenu = document.createElement('div');
            dropdownMenu.className = 'position-absolute bg-white shadow rounded mt-1 py-1 d-none';
            dropdownMenu.style.zIndex = '1000';
            dropdownMenu.style.minWidth = '150px';
            dropdownMenu.style.right = '0';
            
            // Add date range options
            const dateRanges = [
                { text: 'Hôm nay', value: 'today' },
                { text: 'Hôm qua', value: 'yesterday' },
                { text: 'Tuần này', value: 'this-week' },
                { text: 'Tuần trước', value: 'last-week' },
                { text: 'Tháng này', value: 'this-month' },
                { text: 'Tháng trước', value: 'last-month' },
                { text: 'Năm nay', value: 'this-year' }
            ];
            
            dateRanges.forEach(range => {
                const option = document.createElement('a');
                option.href = '#';
                option.className = 'dropdown-item px-3 py-2 small';
                option.textContent = range.text;
                option.setAttribute('data-value', range.value);
                option.style.cursor = 'pointer';
                option.style.color = '#3a3b45';
                option.addEventListener('click', function(e) {
                    e.preventDefault();
                    updateDateRange(range.text, range.value);
                    dropdownMenu.classList.add('d-none');
                });
                dropdownMenu.appendChild(option);
            });
            
            // Position dropdown relative to button
            const buttonContainer = dateRangeBtn.parentNode;
            buttonContainer.style.position = 'relative';
            buttonContainer.appendChild(dropdownMenu);
            
            // Toggle dropdown on button click
            dateRangeBtn.addEventListener('click', function() {
                dropdownMenu.classList.toggle('d-none');
            });
            
            // Close dropdown when clicking elsewhere
            document.addEventListener('click', function(event) {
                if (!buttonContainer.contains(event.target)) {
                    dropdownMenu.classList.add('d-none');
                }
            });
        }
        
        // Handle updating selected date range
        function updateDateRange(text, value) {
            const dateRangeBtn = document.querySelector('.dropdown-toggle');
            
            // Update button text
            const icon = dateRangeBtn.querySelector('i');
            dateRangeBtn.innerHTML = '';
            dateRangeBtn.appendChild(icon);
            dateRangeBtn.appendChild(document.createTextNode(' ' + text));
            
            // Update charts based on selected date range
            updateChartsForDateRange(value);
        }
        
        // Export dashboard data as CSV
        function exportDashboardData() {
            try {
                // Access the text content directly from the page
                const totalUsers = document.querySelector('.stat-card.users .value').textContent.trim();
                const totalProducts = document.querySelector('.stat-card.products .value').textContent.trim();
                const totalOrders = document.querySelector('.stat-card.orders .value').textContent.trim();
                const totalRevenue = document.querySelector('.stat-card.revenue .value').textContent.trim().replace('$', '');
                
                console.log("Exporting values:", totalUsers, totalProducts, totalOrders, totalRevenue);
                
                // Create CSV content without data URL prefix
                const csvRows = [];
                csvRows.push('Metric,Value');
                csvRows.push(`Total Users,${totalUsers}`);
                csvRows.push(`Total Products,${totalProducts}`);
                csvRows.push(`Total Orders,${totalOrders}`);
                csvRows.push(`Total Revenue,${totalRevenue}`);
                
                // Create blob and download
                const csvString = csvRows.join('\n');
                const blob = new Blob([csvString], { type: 'text/csv;charset=utf-8;' });
                
                // Create download link for the blob
                const url = URL.createObjectURL(blob);
                const link = document.createElement("a");
                link.setAttribute("href", url);
                link.setAttribute("download", "dashboard_data.csv");
                link.style.visibility = 'hidden';
                document.body.appendChild(link);
                
                // Trigger download and cleanup
                link.click();
                document.body.removeChild(link);
                URL.revokeObjectURL(url);
                
                console.log("Export completed successfully");
            } catch (e) {
                console.error("Error exporting data:", e);
                alert("Có lỗi khi xuất dữ liệu bảng điều khiển: " + e.message);
            }
        }
        
        // Update charts based on selected date range
        function updateChartsForDateRange(range) {
            // Show loading state
            const chartContainers = document.querySelectorAll('.chart-container');
            chartContainers.forEach(container => {
                // Add loading overlay
                container.classList.add('position-relative');
                const loadingOverlay = document.createElement('div');
                loadingOverlay.className = 'position-absolute w-100 h-100 d-flex justify-content-center align-items-center bg-white bg-opacity-75';
                loadingOverlay.style.top = '0';
                loadingOverlay.style.left = '0';
                loadingOverlay.style.zIndex = '10';
                
                const spinner = document.createElement('div');
                spinner.className = 'spinner-border text-primary';
                spinner.setAttribute('role', 'status');
                spinner.innerHTML = '<span class="visually-hidden">Đang tải...</span>';
                
                loadingOverlay.appendChild(spinner);
                container.appendChild(loadingOverlay);
            });
            
            // AJAX request to get data from server based on date range
            fetch('${pageContext.request.contextPath}/api/revenue-data?range=' + range)
                .then(response => response.json())
                .then(data => {
                    // Update revenue chart with actual data
                    if (window.revenueChart) {
                        window.revenueChart.data.labels = data.labels;
                        window.revenueChart.data.datasets[0].data = data.revenueData;
                        window.revenueChart.update();
                    }
                    
                    // Update order status chart with actual data
                    if (window.ordersChart) {
                        window.ordersChart.data.labels = ['Đang chờ', 'Đang giao', 'Hoàn thành', 'Hoàn trả', 'Đã hủy', 'Đã hoàn tiền'];
                        window.ordersChart.data.datasets[0].data = data.orderStatusData;
                        window.ordersChart.update();
                    }
                    
                    // Remove loading overlays
                    chartContainers.forEach(container => {
                        const overlay = container.querySelector('.position-absolute');
                        if (overlay) overlay.remove();
                    });
                })
                .catch(error => {
                    console.error('Failed to fetch chart data:', error);
                    
                    // If API call fails, use static data instead
                    const staticData = getStaticDataForRange(range);
                    
                    // Update charts with static data
                    if (window.revenueChart) {
                        window.revenueChart.data.labels = staticData.labels;
                        window.revenueChart.data.datasets[0].data = staticData.revenueData;
                        window.revenueChart.update();
                    }
                    
                    if (window.ordersChart) {
                        window.ordersChart.data.labels = ['Đang chờ', 'Đang giao', 'Hoàn thành', 'Hoàn trả', 'Đã hủy', 'Đã hoàn tiền'];
                        window.ordersChart.data.datasets[0].data = staticData.orderStatusData;
                        window.ordersChart.update();
                    }
                    
                    // Remove loading overlays
                    chartContainers.forEach(container => {
                        const overlay = container.querySelector('.position-absolute');
                        if (overlay) overlay.remove();
                    });
                    
                    // Alert user
                    console.warn('Using static fallback data for charts');
                });
        }
        
        // Get static data for different date ranges (fallback)
        function getStaticDataForRange(range) {
            const staticData = {
                'today': {
                    labels: ['6h', '9h', '12h', '15h', '18h', '21h'],
                    revenueData: [150, 300, 450, 400, 650, 700],
                    orderStatusData: [10, 25, 65]
                },
                'yesterday': {
                    labels: ['6h', '9h', '12h', '15h', '18h', '21h'],
                    revenueData: [120, 270, 420, 380, 600, 650],
                    orderStatusData: [15, 20, 65]
                },
                'this-week': {
                    labels: ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'CN'],
                    revenueData: [1200, 1400, 1100, 1700, 1900, 2100, 1800],
                    orderStatusData: [15, 25, 60]
                },
                'last-week': {
                    labels: ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'CN'],
                    revenueData: [1100, 1300, 1000, 1600, 1800, 2000, 1700],
                    orderStatusData: [20, 20, 60]
                },
                'this-month': {
                    labels: ['Tuần 1', 'Tuần 2', 'Tuần 3', 'Tuần 4', 'Tuần 5'],
                    revenueData: [5000, 6500, 7000, 8000],
                    orderStatusData: [15, 25, 60]
                },
                'last-month': {
                    labels: ['Tuần 1', 'Tuần 2', 'Tuần 3', 'Tuần 4', 'Tuần 5'],
                    revenueData: [4500, 6000, 6500, 7500],
                    orderStatusData: [20, 20, 60]
                },
                'this-year': {
                    labels: ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6', 'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'],
                    revenueData: [1000, 1500, 1200, 1800, 2000, 2500, 2800, 3200, 3500, 3200, 2800, 4000],
                    orderStatusData: [10, 30, 60]
                }
            };
            
            return staticData[range] || staticData['this-week'];
        }

        function initializeCharts(data) {
            // Khởi tạo biểu đồ doanh thu với labels và data thật từ backend
            const revenueCanvas = document.getElementById('revenueChart');
            if (revenueCanvas) {
                const revenueCtx = revenueCanvas.getContext('2d');
                const gradientFill = revenueCtx.createLinearGradient(0, 0, 0, 400);
                gradientFill.addColorStop(0, 'rgba(78, 115, 223, 0.4)');
                gradientFill.addColorStop(1, 'rgba(78, 115, 223, 0)');
                window.revenueChart = new Chart(revenueCtx, {
                    type: 'line',
                    data: {
                        labels: data.labels,
                        datasets: [{
                            label: 'Doanh thu',
                            data: data.revenueData,
                            borderColor: '#4e73df',
                            backgroundColor: gradientFill,
                            tension: 0.4,
                            pointRadius: 3,
                            pointBackgroundColor: '#4e73df',
                            pointBorderColor: '#fff',
                            pointHoverRadius: 6,
                            pointHoverBackgroundColor: '#4e73df',
                            pointHoverBorderColor: '#fff',
                            pointHitRadius: 10,
                            fill: true,
                            borderWidth: 3
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        layout: {
                            padding: {
                                left: 10,
                                right: 25,
                                top: 25,
                                bottom: 0
                            }
                        },
                        scales: {
                            x: {
                                grid: {
                                    display: false,
                                    drawBorder: false
                                },
                                ticks: {
                                    maxTicksLimit: 8,
                                    padding: 10,
                                    color: '#858796'
                                }
                            },
                            y: {
                                ticks: {
                                    maxTicksLimit: 5,
                                    padding: 10,
                                    color: '#858796',
                                    callback: function(value) {
                                        return value.toLocaleString('vi-VN') + ' đ';
                                    }
                                },
                                grid: {
                                    color: "rgb(234, 236, 244)",
                                    zeroLineColor: "rgb(234, 236, 244)",
                                    drawBorder: false,
                                    borderDash: [2],
                                    zeroLineBorderDash: [2]
                                }
                            }
                        },
                        plugins: {
                            legend: {
                                display: false
                            },
                            tooltip: {
                                backgroundColor: "#fff",
                                bodyColor: "#858796",
                                titleColor: "#6e707e",
                                titleMarginBottom: 10,
                                borderColor: '#dddfeb',
                                borderWidth: 1,
                                padding: 15,
                                displayColors: false,
                                intersect: false,
                                mode: 'index',
                                caretPadding: 10,
                                callbacks: {
                                    label: function(context) {
                                        return 'Doanh thu: ' + context.parsed.y.toLocaleString('vi-VN') + ' đ';
                                    }
                                }
                            }
                        }
                    }
                });
            }
            // Khởi tạo biểu đồ trạng thái đơn hàng
            const ordersCanvas = document.getElementById('ordersChart');
            if (ordersCanvas) {
                const ordersCtx = ordersCanvas.getContext('2d');
                window.ordersChart = new Chart(ordersCtx, {
                    type: 'doughnut',
                    data: {
                        labels: ['Đang chờ', 'Đang giao', 'Hoàn thành', 'Hoàn trả', 'Đã hủy', 'Đã hoàn tiền'],
                        datasets: [{
                            data: data.orderStatusData,
                            backgroundColor: [
                                '#f6c23e', // Đang chờ
                                '#36b9cc', // Đang giao
                                '#1cc88a', // Hoàn thành
                                '#7c43bd', // Hoàn trả
                                '#e74a3b', // Đã hủy
                                '#858796'  // Đã hoàn tiền
                            ],
                            hoverBackgroundColor: [
                                '#be3d30',
                                '#dda20a',
                                '#17a673',
                                '#5f3dc4',
                                '#be3d30',
                                '#6c757d'
                            ],
                            hoverOffset: 5,
                            hoverBorderColor: "rgba(234, 236, 244, 1)",
                            borderWidth: 2
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        cutout: '75%',
                        plugins: {
                            legend: {
                                display: false
                            },
                            tooltip: {
                                backgroundColor: "#fff",
                                bodyColor: "#858796",
                                titleColor: "#6e707e",
                                borderColor: '#dddfeb',
                                borderWidth: 1,
                                displayColors: false,
                                padding: 15,
                                callbacks: {
                                    label: function(context) {
                                        return context.label + ': ' + context.parsed + '%';
                                    }
                                }
                            }
                        },
                        animation: {
                            animateRotate: true,
                            animateScale: true
                        }
                    }
                });
            }
        }
    </script>
</body>
</html>